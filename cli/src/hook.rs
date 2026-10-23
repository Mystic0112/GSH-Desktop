//! `cockpit hook` — helper que os agentes invocam nos hooks de ciclo de vida.
//! Serve **dois harnesses**, instalados pelos `HookInstaller`s do app:
//!
//! - **Claude Code** (`~/.claude/settings.json`)
//! - **Codex CLI** (`~/.codex/hooks.json` + trust em `~/.codex/config.toml`)
//!
//! Os dois usam o mesmo envelope: um JSON pelo stdin com `hook_event_name`,
//! `session_id`, `transcript_path` etc. Traduzimos num status de turno
//! (working / waiting / idle) e mandamos pro Cockpit pelo mesmo socket da CLI,
//! discriminado por ausência de `type:"cmd"`. Este helper é **agnóstico de
//! harness**: só o conjunto de eventos difere, e o `status_for` cobre a união.
//!
//! Por que socket e não OSC na PTY: os agentes rodam os hooks SEM terminal
//! controlador (escrever em /dev/tty falha com ENXIO). O app injeta no env da
//! PTY o `COCKPIT_PANE_ID` (roteamento) e o `COCKPIT_STATUS_SOCK` (caminho do
//! socket); o hook herda os dois. Sessões de agente fora do Cockpit não têm
//! essas envs, então o hook é no-op (gate natural).
//!
//! **Nunca escreve no stdout** (participa do protocolo de hook) e **nunca falha
//! barulhento**: qualquer erro é engolido pra não atrapalhar o turno.

use std::io::{Read, Write};

use serde_json::{json, Value};

use crate::util::env_non_empty;

/// Executa o hook. Sempre retorna sem erro visível.
pub fn run(args: &[String]) -> ! {
    let _ = try_run(harness_from(args));
    std::process::exit(0)
}

/// Lê `--harness <nome>` dos argumentos. Default `claude`: entries instalados
/// por versões anteriores não passam a flag, e todos eles são do Claude Code.
fn harness_from(args: &[String]) -> String {
    let mut it = args.iter();
    while let Some(a) = it.next() {
        if a == "--harness" {
            if let Some(v) = it.next() {
                if !v.trim().is_empty() {
                    return v.trim().to_string();
                }
            }
        } else if let Some(v) = a.strip_prefix("--harness=") {
            if !v.trim().is_empty() {
                return v.trim().to_string();
            }
        }
    }
    "claude".to_string()
}

fn try_run(harness: String) -> Option<()> {
    let pane_id = env_non_empty("COCKPIT_PANE_ID")?; // não é sessão do Cockpit
    let sock = env_non_empty("COCKPIT_STATUS_SOCK");
    let port = env_non_empty("COCKPIT_STATUS_PORT").and_then(|p| p.parse::<u16>().ok());
    if sock.is_none() && port.is_none() {
        return None;
    }

    let mut raw = String::new();
    std::io::stdin().read_to_string(&mut raw).ok()?;
    if raw.trim().is_empty() {
        return None;
    }
    let decoded: Value = serde_json::from_str(&raw).ok()?;
    if !decoded.is_object() {
        return None;
    }

    let event = str_field(&decoded, "hook_event_name");
    let status = status_for(&event, &decoded)?; // evento que não nos interessa

    let mut payload = json!({
        "paneId": pane_id,
        "st": status,
        // Evento cru — o app usa pra distinguir INÍCIO de turno
        // (UserPromptSubmit) de atividade mid-turn (Pre/PostToolUse) e descartar
        // um 'working' tardio que chega fora de ordem depois do 'idle' (Stop),
        // evitando o spinner eterno. Cada hook é um processo separado abrindo
        // seu próprio socket, sem ordem garantida entre eles.
        "ev": event,
        "sid": str_field(&decoded, "session_id"),
        "tx": str_field(&decoded, "transcript_path"),
        // Quem emitiu o evento. O app precisa disso pra retomar a sessão com o
        // comando certo (`claude --resume <id>` vs `codex resume <id>`) — o
        // session-id sozinho não diz de quem é.
        "hn": harness,
    });
    // Só o Codex manda `turn_id`. Transportamos quando existe: identifica o
    // turno sem depender da ordem de chegada dos hooks (o `ev` continua sendo
    // o que o app consome hoje).
    let turn = str_field(&decoded, "turn_id");
    if !turn.is_empty() {
        payload["tid"] = json!(turn);
    }
    // "Quem mexeu no quê": arquivos que um PostToolUse de edição tocou.
    let files = touched_files(&event, &decoded);
    if !files.is_empty() {
        payload["files"] = json!(files);
    }
    // Token só importa no TCP (loopback é acessível por qualquer processo
    // local); no UDS a permissão do socket já protege.
    if let Ok(tok) = std::env::var("COCKPIT_STATUS_TOKEN") {
        payload["tok"] = json!(tok);
    }

    let mut line = payload.to_string();
    line.push('\n');

    #[cfg(unix)]
    if let Some(path) = sock.as_deref() {
        let mut s = std::os::unix::net::UnixStream::connect(path).ok()?;
        s.write_all(line.as_bytes()).ok()?;
        let _ = s.flush();
        return Some(());
    }
    #[cfg(not(unix))]
    let _ = sock.as_deref();

    let mut s = std::net::TcpStream::connect(("127.0.0.1", port?)).ok()?;
    s.write_all(line.as_bytes()).ok()?;
    let _ = s.flush();
    Some(())
}

/// Campo string do JSON do hook, com `""` quando ausente (igual ao Dart, que
/// faz `(json['x'] ?? '').toString()`).
fn str_field(v: &Value, key: &str) -> String {
    match v.get(key) {
        Some(Value::String(s)) => s.clone(),
        Some(Value::Null) | None => String::new(),
        Some(other) => other.to_string(),
    }
}

const PATCH_BEGIN: &str = "*** Begin Patch";

/// Caminhos **absolutos** que um `PostToolUse` de edição tocou. Claude:
/// `Edit`/`Write`/`MultiEdit` (`file_path`) e `NotebookEdit` (`notebook_path`).
/// Codex: o patch do `apply_patch` (cabeçalhos `*** Add/Update/Delete File:` e
/// `*** Move to:`), achado em qualquer string do `tool_input`. Relativo resolve
/// contra o `cwd` do envelope; formato desconhecido = vazio (nunca falha).
pub fn touched_files(event: &str, json: &Value) -> Vec<String> {
    if event != "PostToolUse" {
        return Vec::new();
    }
    let input = json.get("tool_input").unwrap_or(&Value::Null);
    let raw: Vec<String> = match str_field(json, "tool_name").as_str() {
        "Edit" | "Write" | "MultiEdit" => str_at(input, "file_path"),
        "NotebookEdit" => str_at(input, "notebook_path"),
        _ => {
            let mut out = Vec::new();
            patch_paths(input, &mut out);
            out
        }
    };
    let cwd = str_field(json, "cwd");
    let mut files: Vec<String> = Vec::new();
    for p in raw {
        let path = std::path::Path::new(&p);
        let abs = if path.is_absolute() {
            p.clone()
        } else if !cwd.is_empty() {
            std::path::Path::new(&cwd).join(path).to_string_lossy().into_owned()
        } else {
            continue; // sem cwd não dá pra ancorar
        };
        if !files.contains(&abs) {
            files.push(abs);
        }
    }
    files
}

fn str_at(v: &Value, key: &str) -> Vec<String> {
    match v.get(key).and_then(Value::as_str) {
        Some(s) if !s.trim().is_empty() => vec![s.trim().to_string()],
        _ => Vec::new(),
    }
}

/// Varre o `tool_input` atrás de um patch do Codex (string que começa com
/// `*** Begin Patch`, ou um `apply_patch <<EOF` de shell) e coleta os caminhos.
fn patch_paths(v: &Value, out: &mut Vec<String>) {
    match v {
        Value::String(s) => {
            let start = match s.find(PATCH_BEGIN) {
                Some(i) if s[..i].trim().is_empty() || s[..i].contains("apply_patch") => i,
                _ => return,
            };
            for line in s[start..].lines() {
                let line = line.trim_end_matches('\r');
                for prefix in [
                    "*** Add File: ",
                    "*** Update File: ",
                    "*** Delete File: ",
                    "*** Move to: ",
                ] {
                    if let Some(p) = line.strip_prefix(prefix) {
                        if !p.trim().is_empty() {
                            out.push(p.trim().to_string());
                        }
                    }
                }
            }
        }
        Value::Array(items) => items.iter().for_each(|i| patch_paths(i, out)),
        Value::Object(map) => map.values().for_each(|i| patch_paths(i, out)),
        _ => {}
    }
}

/// Mapeia o evento de hook num status de turno, ou `None` se o evento não deve
/// mover o indicador.
///
/// Cobre a **união** dos eventos do Claude Code e do Codex CLI — os nomes
/// coincidem onde a semântica coincide. Diferenças que importam:
///
/// - `Notification` só existe no Claude; `PermissionRequest` só no Codex. Os
///   dois significam "precisa do usuário", mas o do Codex é explícito e não
///   exige a heurística de texto.
/// - O desvio de `PreToolUse` bloqueante é do Claude (ferramenta que trava
///   esperando resposta sem emitir `Notification`). No Codex é inerte: aquelas
///   ferramentas não existem lá, e a aprovação tem evento próprio.
/// - `SubagentStart`/`SubagentStop` e `PreCompact`/`PostCompact` (Codex) são
///   ignorados de propósito: subagente e compactação não devem mexer no
///   indicador da aba, que representa a sessão principal.
pub fn status_for(event: &str, json: &Value) -> Option<&'static str> {
    match event {
        "UserPromptSubmit" | "PostToolUse" => Some("working"),
        "PreToolUse" => {
            // Ferramentas que por definição BLOQUEIAM esperando o usuário
            // (formulário do plan mode, aprovação de plano) não emitem
            // `Notification` — o último hook antes do bloqueio é este PreToolUse.
            // Sem este desvio o app fica em `working` (spinner eterno) sem
            // chime/notificação. O `PostToolUse` que chega quando o usuário
            // responde volta pra `working` normalmente.
            let tool = str_field(json, "tool_name");
            const BLOCKING: [&str; 2] = ["AskUserQuestion", "ExitPlanMode"];
            Some(if BLOCKING.contains(&tool.as_str()) {
                "waiting"
            } else {
                "working"
            })
        }
        "Notification" => {
            // Notification cobre "precisa de aprovação" e "ocioso esperando input".
            let hint = format!(
                "{} {}",
                str_field(json, "notification_type"),
                str_field(json, "message")
            )
            .to_lowercase();
            Some(if hint.contains("idle") {
                "idle"
            } else {
                "waiting"
            })
        }
        // Codex: o pedido de aprovação tem evento próprio, sem heurística.
        "PermissionRequest" => Some("waiting"),
        "Stop" | "SessionStart" | "SessionEnd" => Some("idle"),
        // Explicitamente inertes (Codex): subagente e compactação não são o
        // turno da aba. Listados pra deixar claro que é decisão, não omissão.
        "SubagentStart" | "SubagentStop" | "PreCompact" | "PostCompact" => None,
        _ => None,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn eventos_de_trabalho() {
        assert_eq!(status_for("UserPromptSubmit", &json!({})), Some("working"));
        assert_eq!(status_for("PostToolUse", &json!({})), Some("working"));
    }

    #[test]
    fn pretooluse_bloqueante_vira_waiting() {
        let bloqueia = json!({"tool_name": "AskUserQuestion"});
        assert_eq!(status_for("PreToolUse", &bloqueia), Some("waiting"));
        let plano = json!({"tool_name": "ExitPlanMode"});
        assert_eq!(status_for("PreToolUse", &plano), Some("waiting"));
        let comum = json!({"tool_name": "Bash"});
        assert_eq!(status_for("PreToolUse", &comum), Some("working"));
        // sem tool_name continua working
        assert_eq!(status_for("PreToolUse", &json!({})), Some("working"));
    }

    #[test]
    fn notification_distingue_idle_de_waiting() {
        let idle = json!({"message": "Claude is idle waiting for input"});
        assert_eq!(status_for("Notification", &idle), Some("idle"));
        let tipo_idle = json!({"notification_type": "IDLE"});
        assert_eq!(status_for("Notification", &tipo_idle), Some("idle"));
        let aprovacao = json!({"message": "needs your approval"});
        assert_eq!(status_for("Notification", &aprovacao), Some("waiting"));
    }

    #[test]
    fn fim_de_turno_e_sessao_sao_idle() {
        for ev in ["Stop", "SessionStart", "SessionEnd"] {
            assert_eq!(status_for(ev, &json!({})), Some("idle"));
        }
    }

    #[test]
    fn evento_desconhecido_nao_move_indicador() {
        assert_eq!(status_for("", &json!({})), None);
        assert_eq!(status_for("Whatever", &json!({})), None);
    }

    #[test]
    fn permission_request_do_codex_e_waiting() {
        // Payload real do Codex: nada de texto pra interpretar, o evento já diz.
        let ev = json!({"hook_event_name": "PermissionRequest", "tool_name": "shell"});
        assert_eq!(status_for("PermissionRequest", &ev), Some("waiting"));
    }

    #[test]
    fn subagente_e_compactacao_do_codex_sao_inertes() {
        for ev in ["SubagentStart", "SubagentStop", "PreCompact", "PostCompact"] {
            assert_eq!(
                status_for(ev, &json!({})),
                None,
                "{ev} não deve mover a aba"
            );
        }
    }

    #[test]
    fn eventos_do_codex_cobrem_o_ciclo_de_turno() {
        // Sequência observada numa sessão real de `codex exec`.
        let ciclo = [
            ("SessionStart", "idle"),
            ("UserPromptSubmit", "working"),
            ("PreToolUse", "working"),
            ("PostToolUse", "working"),
            ("PermissionRequest", "waiting"),
            ("Stop", "idle"),
            ("SessionEnd", "idle"),
        ];
        for (ev, esperado) in ciclo {
            assert_eq!(status_for(ev, &json!({})), Some(esperado), "evento {ev}");
        }
    }

    #[test]
    fn touched_files_do_claude() {
        let edit = json!({"tool_name": "Edit", "cwd": "/repo",
            "tool_input": {"file_path": "/repo/a.rs", "old_string": "x"}});
        assert_eq!(touched_files("PostToolUse", &edit), vec!["/repo/a.rs"]);
        let write = json!({"tool_name": "Write", "cwd": "/repo",
            "tool_input": {"file_path": "src/b.rs"}});
        assert_eq!(touched_files("PostToolUse", &write), vec!["/repo/src/b.rs"]);
        let multi = json!({"tool_name": "MultiEdit", "tool_input": {"file_path": "/r/c.rs"}});
        assert_eq!(touched_files("PostToolUse", &multi), vec!["/r/c.rs"]);
        let nb = json!({"tool_name": "NotebookEdit", "tool_input": {"notebook_path": "/r/n.ipynb"}});
        assert_eq!(touched_files("PostToolUse", &nb), vec!["/r/n.ipynb"]);
        // PreToolUse não conta: o arquivo ainda não mudou.
        assert!(touched_files("PreToolUse", &edit).is_empty());
    }

    #[test]
    fn touched_files_do_patch_do_codex() {
        let patch = "*** Begin Patch\n*** Add File: new.txt\n+oi\n\
            *** Update File: src/a.rs\n*** Move to: src/b.rs\n@@\n-x\n+y\n\
            *** Delete File: /abs/old.rs\n*** End Patch\n";
        let ev = json!({"tool_name": "apply_patch", "cwd": "/repo",
            "tool_input": {"command": patch}});
        assert_eq!(
            touched_files("PostToolUse", &ev),
            vec!["/repo/new.txt", "/repo/src/a.rs", "/repo/src/b.rs", "/abs/old.rs"]
        );
        // Mesmo patch chegando como argv de shell.
        let shell = json!({"tool_name": "shell", "cwd": "/repo",
            "tool_input": {"command": ["apply_patch", patch]}});
        assert_eq!(touched_files("PostToolUse", &shell).len(), 4);
    }

    #[test]
    fn touched_files_formato_desconhecido_e_vazio() {
        for ev in [
            json!({}),
            json!({"tool_name": "Bash", "tool_input": {"command": "ls"}}),
            json!({"tool_name": "Edit", "tool_input": "lixo"}),
            json!({"tool_name": "Write", "tool_input": {"file_path": "rel.rs"}}), // sem cwd
            json!({"tool_name": "Bash", "tool_input": {"command": "echo '*** Begin Patch'"}}),
        ] {
            assert!(touched_files("PostToolUse", &ev).is_empty(), "{ev}");
        }
    }

    #[test]
    fn harness_default_e_claude() {
        // Entry antigo (instalado antes da flag existir) só passa `hook`.
        assert_eq!(harness_from(&[]), "claude");
        assert_eq!(harness_from(&["--harness".into()]), "claude");
        assert_eq!(harness_from(&["--harness".into(), "  ".into()]), "claude");
    }

    #[test]
    fn harness_aceita_as_duas_formas() {
        assert_eq!(harness_from(&["--harness".into(), "codex".into()]), "codex");
        assert_eq!(harness_from(&["--harness=codex".into()]), "codex");
    }

    #[test]
    fn str_field_normaliza_ausente_e_nao_string() {
        assert_eq!(str_field(&json!({}), "x"), "");
        assert_eq!(str_field(&json!({"x": null}), "x"), "");
        assert_eq!(str_field(&json!({"x": "v"}), "x"), "v");
        assert_eq!(str_field(&json!({"x": 7}), "x"), "7");
    }
}
