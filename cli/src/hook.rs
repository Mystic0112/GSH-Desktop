//! `gsh hook` — helper que os agentes invocam nos hooks de ciclo de vida.
//! Serve **dois harnesses**, instalados pelos `HookInstaller`s do app:
//!
//! - **Claude Code** (`~/.claude/settings.json`)
//! - **Codex CLI** (`~/.codex/hooks.json` + trust em `~/.codex/config.toml`)
//!
//! Os dois usam o mesmo envelope: um JSON pelo stdin com `hook_event_name`,
//! `session_id`, `transcript_path` etc. Traduzimos num status de turno
//! (working / waiting / idle) e mandamos pro GSH pelo mesmo socket da CLI,
//! discriminado por ausência de `type:"cmd"`. Este helper é **agnóstico de
//! harness**: só o conjunto de eventos difere, e o `status_for` cobre a união.
//!
//! Por que socket e não OSC na PTY: os agentes rodam os hooks SEM terminal
//! controlador (escrever em /dev/tty falha com ENXIO). O app injeta no env da
//! PTY o `GSH_PANE_ID` (roteamento) e o `GSH_STATUS_SOCK` (caminho do
//! socket); o hook herda os dois. Sessões de agente fora do GSH não têm
//! essas envs, então o hook não manda nada pelo socket (gate natural).
//!
//! **Fazenda do GSH Desktop:** com ou sem aba, o último status de cada sessão
//! vai para `~/.gsh/farm/<session_id>.json` ([record_farm]). É o único
//! jeito de a fazenda saber de um pedido de permissão: ele não aparece no
//! transcript, só no `Notification`.
//!
//! **Nunca escreve no stdout** (participa do protocolo de hook) e **nunca falha
//! barulhento**: qualquer erro é engolido pra não atrapalhar o turno.

use std::io::{Read, Write};

use serde_json::{json, Value};

use std::path::Path;
use std::time::{SystemTime, UNIX_EPOCH};

use crate::util::{env_non_empty, home_dir};

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
    // Hosts protegidos: comando que cite um deles é bloqueado antes de rodar,
    // em qualquer sessão da máquina (não só numa aba do GSH).
    if event == "PreToolUse" {
        if let Some(home) = home_dir() {
            let hosts = protected_hosts(&Path::new(&home).join(".gsh").join("protected-hosts.json"));
            if let Some(host) = guard_hit(&decoded, &hosts) {
                eprintln!(
                    "GSH Desktop bloqueou este comando: ele cita o host protegido \"{host}\". \
                     Peça ao usuário para rodar à mão ou remover o host em Configurações > Claude Code > Segurança."
                );
                std::process::exit(2);
            }
        }
    }
    let status = status_for(&event, &decoded);
    if let Some(home) = home_dir() {
        let dir = Path::new(&home).join(".gsh").join("farm");
        record_farm(&dir, &str_field(&decoded, "session_id"), &event, status, &harness);
    }
    let status = status?; // evento que não nos interessa

    let pane_id = env_non_empty("GSH_PANE_ID")?; // não é sessão do GSH
    let sock = env_non_empty("GSH_STATUS_SOCK");
    let port = env_non_empty("GSH_STATUS_PORT").and_then(|p| p.parse::<u16>().ok());
    if sock.is_none() && port.is_none() {
        return None;
    }

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
    if let Ok(tok) = std::env::var("GSH_STATUS_TOKEN") {
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

/// Lista de hosts protegidos (`~/.gsh/protected-hosts.json`, array de
/// strings). Arquivo ausente ou inválido = nenhum.
fn protected_hosts(path: &Path) -> Vec<String> {
    let Ok(raw) = std::fs::read_to_string(path) else { return Vec::new() };
    let Ok(v) = serde_json::from_str::<Value>(&raw) else { return Vec::new() };
    v.as_array()
        .map(|a| {
            a.iter()
                .filter_map(|x| x.as_str())
                .map(|s| s.trim().to_lowercase())
                .filter(|s| !s.is_empty())
                .collect()
        })
        .unwrap_or_default()
}

/// Ferramentas que executam comando: o guard olha só o input delas (um
/// `Read` de um arquivo chamado prod.md não é acesso ao host).
const SHELL_TOOLS: [&str; 3] = ["Bash", "shell", "exec_command"];

/// O host protegido que o input da ferramenta cita, se algum. O host conta
/// como palavra: "prod" casa com "ssh prod", "user@prod" e "prod.x.com", mas
/// não com "production" nem "--prod".
pub fn guard_hit(json: &Value, hosts: &[String]) -> Option<String> {
    if hosts.is_empty() || !SHELL_TOOLS.contains(&str_field(json, "tool_name").as_str()) {
        return None;
    }
    let input = json.get("tool_input").map(|v| v.to_string()).unwrap_or_default().to_lowercase();
    let is_word = |c: char| c.is_ascii_alphanumeric() || c == '_' || c == '-';
    for host in hosts {
        let mut from = 0;
        while let Some(i) = input[from..].find(host.as_str()) {
            let start = from + i;
            let end = start + host.len();
            let before_ok = start == 0 || !is_word(input[..start].chars().next_back().unwrap());
            let after_ok = end == input.len() || !is_word(input[end..].chars().next().unwrap());
            if before_ok && after_ok {
                return Some(host.clone());
            }
            from = end;
        }
    }
    None
}

/// Grava o último status da sessão em `<dir>/<sid>.json` (`st`, `ev`, `ts` em
/// ms, `hn`) para a fazenda. `SessionEnd` apaga o arquivo. Escrita atômica
/// (tmp + rename): a fazenda lê a cada 2s e nunca pode ver meio JSON.
fn record_farm(dir: &Path, sid: &str, event: &str, status: Option<&str>, harness: &str) {
    // O id vira nome de arquivo: só aceita o formato de UUID/slug.
    if sid.is_empty()
        || !sid
            .chars()
            .all(|c| c.is_ascii_alphanumeric() || c == '-' || c == '_')
    {
        return;
    }
    let path = dir.join(format!("{sid}.json"));
    if event == "SessionEnd" {
        let _ = std::fs::remove_file(&path);
        return;
    }
    let Some(st) = status else { return };
    if std::fs::create_dir_all(dir).is_err() {
        return;
    }
    let ts = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|d| d.as_millis() as u64)
        .unwrap_or(0);
    let body = json!({"st": st, "ev": event, "ts": ts, "hn": harness}).to_string();
    let tmp = dir.join(format!(".{sid}.{}.tmp", std::process::id()));
    if std::fs::write(&tmp, body).is_ok() && std::fs::rename(&tmp, &path).is_err() {
        let _ = std::fs::remove_file(&tmp);
    }
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
    fn hosts_protegidos_bloqueiam_so_comando_que_cita_o_host() {
        let hosts = vec!["prod".to_string(), "homolog.gorila.com".to_string()];
        let cmd = |c: &str| json!({"tool_name": "Bash", "tool_input": {"command": c}});
        assert_eq!(guard_hit(&cmd("ssh prod"), &hosts).as_deref(), Some("prod"));
        assert_eq!(guard_hit(&cmd("scp a.txt deploy@prod.gorila.com:/x"), &hosts).as_deref(), Some("prod"));
        assert_eq!(guard_hit(&cmd("gsh new-workspace . --host homolog.gorila.com"), &hosts).as_deref(), Some("homolog.gorila.com"));
        assert_eq!(guard_hit(&cmd("npm run build --prod"), &hosts), None);
        assert_eq!(guard_hit(&cmd("echo production"), &hosts), None);
        // Só ferramentas de shell: ler um arquivo com o nome não é acesso.
        let read = json!({"tool_name": "Read", "tool_input": {"file_path": "/docs/prod.md"}});
        assert_eq!(guard_hit(&read, &hosts), None);
        // Codex: input com argv.
        let codex = json!({"tool_name": "shell", "tool_input": {"argv": ["ssh", "prod"]}});
        assert_eq!(guard_hit(&codex, &hosts).as_deref(), Some("prod"));
        assert_eq!(guard_hit(&cmd("ssh prod"), &[]), None);
    }

    #[test]
    fn fazenda_grava_status_e_apaga_no_fim_da_sessao() {
        let dir = std::env::temp_dir().join(format!("farm-test-{}", std::process::id()));
        let sid = "abc-123";
        record_farm(&dir, sid, "Notification", Some("waiting"), "claude");
        let v: Value =
            serde_json::from_str(&std::fs::read_to_string(dir.join("abc-123.json")).unwrap())
                .unwrap();
        assert_eq!(v["st"], "waiting");
        assert_eq!(v["ev"], "Notification");
        assert!(v["ts"].as_u64().unwrap() > 0);
        // Evento sem status não mexe no arquivo.
        record_farm(&dir, sid, "SubagentStart", None, "claude");
        assert!(dir.join("abc-123.json").exists());
        record_farm(&dir, sid, "SessionEnd", Some("idle"), "claude");
        assert!(!dir.join("abc-123.json").exists());
        // Id que não é slug não vira caminho.
        record_farm(&dir, "../x", "Stop", Some("idle"), "claude");
        assert!(!dir.join("../x.json").exists());
        let _ = std::fs::remove_dir_all(&dir);
    }

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
