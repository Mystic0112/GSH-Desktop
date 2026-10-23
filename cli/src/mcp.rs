//! `cockpit mcp --agent <app-id>` — servidor MCP (stdio, JSON-RPC 2.0, uma
//! mensagem por linha) que põe um app desktop (Claude Desktop, Cursor,
//! Antigravity, Codex/ChatGPT) no grafo de agentes como nó **externo**.
//!
//! O app desktop spawna este processo sem env do Cockpit: o transporte acha o
//! app pelo socket bem conhecido (ver `transport::candidate_sockets`). O nó é
//! `ext:<app-id>` no wire — os verbos `msg`/`peers` são os mesmos da CLI, só o
//! `tabId` do emissor muda.
//!
//! Modelo **pull**: o app não empurra nada pro cliente MCP. Mensagens pra este
//! agente ficam numa fila no Cockpit e saem por `wait_messages` (long-poll).
//!
//! **Identidade automática** ([resolve_identity]): o Codex CLI e o app desktop
//! do Codex dividem o `~/.codex/config.toml`, então a MESMA entrada (`--agent
//! codex-desktop`) sobe no Codex de um terminal do Cockpit — onde o sandbox
//! bloqueia a CLI de shell e só o MCP (fora do sandbox) alcança o app. Antes de
//! atender, o servidor pergunta ao app (`mcp-whoami`) se o próprio pid está na
//! árvore de processos de alguma aba; se está, age COMO aquela aba (mesmos
//! verbos da CLI de shell). Senão, cai no nó externo do `--agent`.
//!
//! **`from` por chamada**: o Codex CLI 0.16x roda as sessões num app-server
//! daemon compartilhado (pai = init) que spawna os servidores MCP — sem
//! ancestralidade de aba nem env do Cockpit, e um processo serve várias abas
//! (e o app ChatGPT). Por isso toda ferramenta aceita `from` (id ou label da
//! aba): o app resolve, exige aba de terminal com Codex e age como ela naquela
//! chamada (cursor do `wait_messages` por aba, no app). Sem `from`, vale a
//! identidade do startup.
// ponytail: `from` é a palavra do agente (app local, usuário único); upgrade =
// token por sessão se o Codex um dia repassar env da sessão pro MCP.

use std::collections::HashMap;
use std::io::{BufRead, Write};
use std::time::Duration;

use serde_json::{json, Value};

use crate::transport;
use crate::util::die;

/// Apps desktop aceitos em `--agent` (mesmos ids do app, `DesktopAgentApp.id`).
pub const APPS: [&str; 4] = ["claude-desktop", "cursor", "antigravity-ide", "codex-desktop"];

/// Versão do protocolo MCP quando o cliente não manda a dele.
const PROTOCOL: &str = "2025-06-18";

/// Batimento de presença: o app mostra o nó online enquanto chega um a cada
/// poucos segundos.
// ponytail: heartbeat em vez de conexão persistente — o socket do app é uma
// requisição por conexão; sobrevive a reinício do Cockpit sem reconectar.
const HEARTBEAT: Duration = Duration::from_secs(5);

/// Teto do `wait_messages`: o cliente MCP do Claude Desktop derruba a
/// requisição em ~60s ("Request timed out"), então o long-poll volta antes.
const WAIT_DEFAULT: u64 = 45;
const WAIT_MAX: u64 = 55;
const CALL_TIMEOUT: Duration = Duration::from_secs(10);

/// Transporte injetável (testes rodam sem app): `transport::try_request`.
type Call<'a> = &'a dyn Fn(Value, Duration) -> Result<Value, String>;

const HELP: &str = "cockpit mcp [--agent <app-id>]
  Stdio MCP server that connects an agent to Cockpit's Agents graph. Run
  under a Cockpit terminal tab (e.g. by Codex, whose sandbox blocks the shell
  CLI) it acts as that tab; otherwise as the desktop app --agent names. The
  app runs it from its MCP config (Cockpit's New agent dialog writes that
  entry; Cockpit adds it to ~/.codex/config.toml for Codex). app-id:
  claude-desktop | cursor | antigravity-ide | codex-desktop.
  Tools: peers, send, wait_messages (max 55s per call), list_agents. Each
  takes an optional `from` (tab id or label): a Codex terminal tab passes its
  own id, since Codex's shared app-server daemon spawns this server outside
  the tab's process tree.";

/// Quem este servidor é no grafo: `tab` é o `tabId` no wire (`t3` ou
/// `ext:<app>`).
#[derive(Debug, PartialEq)]
struct Identity {
    tab: String,
    label: String,
    external: bool,
}

pub fn run(args: &[String]) -> ! {
    if args.iter().any(|a| a == "--help" || a == "-h") {
        println!("{HELP}");
        std::process::exit(0);
    }
    let agent = match parse_agent(args) {
        Ok(a) => a,
        Err(e) => die(&format!("cockpit mcp: {e}\n{HELP}"), 2),
    };
    let me = resolve_identity(
        agent.as_deref(),
        crate::util::self_tab_id(),
        ancestry(std::process::id()),
        &transport::try_request,
    )
    .unwrap_or_else(|e| die(&format!("cockpit mcp: {e}"), 2));
    let tab = me.tab.clone();
    let instructions = instructions(&me);

    // Presença é coisa de nó externo; a aba já tem a dela (o PTY).
    if me.external {
        let beat = tab.clone();
        std::thread::spawn(move || loop {
            let _ = transport::try_request(
                json!({"cmd": "ext-ping", "tabId": beat}),
                Duration::from_secs(3),
            );
            std::thread::sleep(HEARTBEAT);
        });
    }

    let call: Call = &transport::try_request;
    for line in std::io::stdin().lock().lines() {
        let Ok(line) = line else { break };
        let line = line.trim();
        if line.is_empty() {
            continue;
        }
        let Ok(req) = serde_json::from_str::<Value>(line) else {
            emit(&rpc_error(Value::Null, -32700, "parse error"));
            continue;
        };
        // `tools/call` pode segurar até WAIT_MAX (wait_messages): roda numa
        // thread pra `ping`/outras chamadas seguirem respondendo.
        if req.get("method").and_then(Value::as_str) == Some("tools/call") {
            let (tab, instructions) = (tab.clone(), instructions.clone());
            std::thread::spawn(move || {
                if let Some(resp) = handle(&req, &tab, &instructions, &transport::try_request) {
                    emit(&resp);
                }
            });
        } else if let Some(resp) = handle(&req, &tab, &instructions, call) {
            emit(&resp);
        }
    }
    std::process::exit(0)
}

/// `Ok(None)` = sem `--agent` (só serve rodando sob uma aba).
fn parse_agent(args: &[String]) -> Result<Option<String>, String> {
    let mut it = args.iter();
    while let Some(a) = it.next() {
        let v = if a == "--agent" {
            it.next().cloned()
        } else {
            a.strip_prefix("--agent=").map(str::to_string)
        };
        if let Some(v) = v {
            return if APPS.contains(&v.as_str()) {
                Ok(Some(v))
            } else {
                Err(format!("unknown --agent {v:?}"))
            };
        }
    }
    Ok(None)
}

/// Este processo e seus ancestrais (`[pid, ppid, …]`): o app acha a aba dona
/// subindo por aqui. Descer das abas não serve no Linux: filho spawnado por
/// uma thread que não a principal (o Codex é tokio) só aparece no
/// `/proc/<pid>/task/<tid>/children` daquela thread. Windows (sem `ps`): só o
/// pid, e o app cai na tabela de processos dele.
fn ancestry(pid: u32) -> Vec<u32> {
    #[cfg(unix)]
    if let Ok(out) = std::process::Command::new("ps")
        .args(["-A", "-o", "pid=", "-o", "ppid="])
        .output()
    {
        return chain(pid, &parse_ps(&String::from_utf8_lossy(&out.stdout)));
    }
    vec![pid]
}

/// `pid ppid` por linha (saída do `ps -o pid= -o ppid=`).
#[cfg_attr(not(unix), allow(dead_code))]
fn parse_ps(table: &str) -> HashMap<u32, u32> {
    table
        .lines()
        .filter_map(|l| {
            let mut it = l.split_whitespace().map(str::parse::<u32>);
            Some((it.next()?.ok()?, it.next()?.ok()?))
        })
        .collect()
}

#[cfg_attr(not(unix), allow(dead_code))]
fn chain(pid: u32, parent: &HashMap<u32, u32>) -> Vec<u32> {
    let mut out = vec![pid];
    // Teto de saltos e corte em ciclo: pid reciclado no meio da leitura.
    while out.len() < 64 {
        match parent.get(out.last().unwrap()) {
            Some(&p) if p > 0 && !out.contains(&p) => out.push(p),
            _ => break,
        }
    }
    out
}

/// Aba sob a qual este processo roda, senão o nó externo de [agent].
///
/// Quem decide é o app (`mcp-whoami`): procura uma raiz de aba em [pids]
/// ([ancestry]; o Codex do terminal é ancestral deste processo). [hint] é o
/// `COCKPIT_TAB_ID` herdado (o Codex só repassa se a entrada listar em
/// `env_vars`); o app só o aceita quando não consegue ver a árvore da aba
/// (WSL, host remoto) — env herdado não prova parentesco: um Cursor aberto de
/// dentro de um terminal do Cockpit herda o env e não é aquela aba.
fn resolve_identity(
    agent: Option<&str>,
    hint: Option<String>,
    pids: Vec<u32>,
    call: Call,
) -> Result<Identity, String> {
    let ext = |app: &str| Identity {
        tab: format!("ext:{app}"),
        label: app.to_string(),
        external: true,
    };
    let tab = |id: String, label: Option<String>| Identity {
        label: label.unwrap_or_else(|| id.clone()),
        tab: id,
        external: false,
    };
    let req = json!({"cmd": "mcp-whoami", "tabId": hint, "args": {"pids": pids}});
    match call(req, CALL_TIMEOUT) {
        Ok(resp) if resp.get("ok") == Some(&Value::Bool(true)) => {
            let data = resp.get("data").cloned().unwrap_or(Value::Null);
            let s = |k: &str| data.get(k).and_then(Value::as_str).map(str::to_string);
            match s("tabId") {
                Some(id) => Ok(tab(id, s("label"))),
                None => agent.map(ext).ok_or_else(|| "malformed mcp-whoami reply".to_string()),
            }
        }
        // App respondeu "não é aba" (ou é antigo e não conhece o verbo).
        Ok(resp) => agent.map(ext).ok_or_else(|| {
            format!(
                "not running under a Cockpit terminal ({}) and no --agent given",
                transport::error_text(&resp)
            )
        }),
        // ponytail: app fora do ar = identidade decidida uma vez, sem retry;
        // o processo vive o tanto da sessão do cliente MCP.
        Err(e) => match (agent, hint) {
            (Some(app), _) => Ok(ext(app)),
            (None, Some(id)) => Ok(tab(id, None)),
            (None, None) => Err(format!("no --agent given and Cockpit is unreachable ({e})")),
        },
    }
}

/// Uma linha no stdout. `println!` segura o lock do stdout pela linha inteira,
/// então threads de `tools/call` não intercalam bytes.
fn emit(v: &Value) {
    let mut out = std::io::stdout().lock();
    let _ = writeln!(out, "{v}");
    let _ = out.flush();
}

fn rpc_error(id: Value, code: i64, message: &str) -> Value {
    json!({"jsonrpc": "2.0", "id": id, "error": {"code": code, "message": message}})
}

/// Responde uma mensagem JSON-RPC. `None` = notificação (sem `id`) ou resposta
/// do cliente: nada a escrever.
fn handle(req: &Value, tab: &str, instructions: &str, call: Call) -> Option<Value> {
    let id = req.get("id").filter(|v| !v.is_null())?.clone();
    let method = req.get("method").and_then(Value::as_str)?;
    let params = req.get("params").cloned().unwrap_or(Value::Null);
    let result = match method {
        "initialize" => json!({
            "protocolVersion": params
                .get("protocolVersion")
                .and_then(Value::as_str)
                .unwrap_or(PROTOCOL),
            "capabilities": {"tools": {}},
            "serverInfo": {"name": "cockpit", "version": crate::VERSION},
            "instructions": instructions,
        }),
        "ping" => json!({}),
        "tools/list" => json!({"tools": tools()}),
        "tools/call" => match call_tool(&params, tab, call) {
            Some(r) => r,
            None => {
                let name = params.get("name").and_then(Value::as_str).unwrap_or("");
                return Some(rpc_error(id, -32602, &format!("unknown tool: {name}")));
            }
        },
        _ => return Some(rpc_error(id, -32601, &format!("method not found: {method}"))),
    };
    Some(json!({"jsonrpc": "2.0", "id": id, "result": result}))
}

fn instructions(me: &Identity) -> String {
    if !me.external {
        return format!(
            "You are connected to Cockpit's Agents graph as the terminal tab \
`{}` ({}). Use these tools to talk to other agents instead of the `cockpit \
msg`/`cockpit peers` shell commands (a sandbox, like Codex's, blocks them). \
Messages to you are typed into your terminal as `[from: <name>] ...` lines; \
wait_messages also returns the ones that arrived since its last call. Talk to \
agents with send; discover them with peers and list_agents.",
            me.label, me.tab
        );
    }
    let agent = &me.label;
    format!(
        "You are connected to Cockpit's Agents graph as the desktop agent \
`{agent}`. Other agents (Claude Code, Codex... in Cockpit terminals) can message \
you, but nothing is pushed to you: messages are queued in Cockpit. Call \
wait_messages to read them (call it once at the start: your role and first task \
may be waiting). Talk to agents with send; discover them with peers and \
list_agents. After sending work, call wait_messages to collect the replies. \
{FROM_HINT}"
    )
}

/// Pista do `from` (descrições e instruções): o Codex de uma aba fala por
/// este servidor sem que ele saiba de qual aba (ver o doc do módulo).
const FROM_HINT: &str = "If you run in a Cockpit terminal tab (e.g. Codex), pass \
from: <your tab id> — it is in the connection message Cockpit sent you.";

/// Schema com `from` (toda ferramenta aceita) mais [props].
fn schema(mut props: Value, required: &[&str]) -> Value {
    props["from"] = json!({
        "type": "string",
        "description": "Your Cockpit tab id (e.g. \"t50\") or tab label, when you \
run in a Cockpit terminal tab. Omit otherwise."
    });
    json!({"type": "object", "properties": props, "required": required})
}

fn tools() -> Value {
    json!([
        {
            "name": "peers",
            "description": format!("List the agents you are connected to on the Cockpit \
canvas: label (the address for send), harness or app, working, maestro, online. \
Message them with send. {FROM_HINT}"),
            "inputSchema": schema(json!({}), &[]),
        },
        {
            "name": "send",
            "description": format!("Send a message to another agent on the Cockpit canvas \
(a terminal agent such as Claude Code or Codex, or another desktop app). `to` is \
its label from peers/list_agents. Terminal agents get it typed into their \
terminal right away, signed with your name. Replies \
come back as messages to you: call wait_messages after dispatching work to \
collect them. {FROM_HINT}"),
            "inputSchema": schema(
                json!({
                    "to": {"type": "string", "description": "Target agent label (or tab id)."},
                    "text": {"type": "string", "description": "Message text."}
                }),
                &["to", "text"],
            ),
        },
        {
            "name": "wait_messages",
            "description": format!("Collect messages addressed to you: from terminal agents \
(`cockpit msg --to <your label>`), other desktop agents, or Cockpit itself (role, \
initial task, connection intros). Returns every message that arrived since \
your last call at once, or waits up to timeout_seconds (default 45, max 55; \
call again to keep waiting) for the first to arrive. Returns \"No messages\" \
on timeout. {FROM_HINT}"),
            "inputSchema": schema(
                json!({
                    "timeout_seconds": {
                        "type": "integer",
                        "minimum": 0,
                        "maximum": WAIT_MAX,
                        "description": "How long to wait for the first message (default 45, max 55)."
                    }
                }),
                &[],
            ),
        },
        {
            "name": "list_agents",
            "description": format!("List every agent in your Cockpit workspace (terminal \
and desktop), including ones you are not connected to: label, harness or app, \
working, maestro, linked. Useful when you are the maestro. {FROM_HINT}"),
            "inputSchema": schema(json!({}), &[]),
        },
    ])
}

/// `None` = ferramenta desconhecida (erro JSON-RPC). Falha do app/transporte
/// vira resultado com `isError`, como o MCP pede pra erro de ferramenta.
fn call_tool(params: &Value, tab: &str, call: Call) -> Option<Value> {
    let name = params.get("name").and_then(Value::as_str).unwrap_or("");
    let args = params.get("arguments").cloned().unwrap_or(Value::Null);
    let str_arg = |k: &str| {
        args.get(k)
            .and_then(Value::as_str)
            .map(str::trim)
            .filter(|s| !s.is_empty())
            .map(str::to_string)
    };
    // `from` vai pro app, que resolve a aba e age como ela (só esta chamada).
    let from = str_arg("from");
    let req = |cmd: &str, mut a: Value| {
        if let Some(f) = &from {
            a["from"] = json!(f);
        }
        json!({"cmd": cmd, "tabId": tab, "args": a})
    };
    let out = match name {
        "peers" => app(call, req("peers", json!({})), CALL_TIMEOUT).map(pretty),
        "list_agents" => app(call, req("agents", json!({})), CALL_TIMEOUT).map(pretty),
        "send" => match (str_arg("to"), str_arg("text")) {
            (Some(to), Some(text)) => {
                app(call, req("msg", json!({"to": to, "text": text})), CALL_TIMEOUT).map(|d| {
                    let to = d.get("to").and_then(Value::as_str).unwrap_or("");
                    format!("Sent to {to}. Call wait_messages to collect the reply.")
                })
            }
            _ => Err("send needs `to` (an agent label) and `text`".to_string()),
        },
        "wait_messages" => {
            let secs = args
                .get("timeout_seconds")
                .and_then(Value::as_u64)
                .unwrap_or(WAIT_DEFAULT)
                .min(WAIT_MAX);
            app(call, req("ext-wait", json!({"timeout": secs})), Duration::from_secs(secs + 10))
            .map(|d| format_messages(&d, secs))
        }
        _ => return None,
    };
    Some(match out {
        Ok(text) => json!({"content": [{"type": "text", "text": text}]}),
        Err(e) => json!({"content": [{"type": "text", "text": e}], "isError": true}),
    })
}

/// `data` da resposta do app, ou o erro em texto pro modelo.
fn app(call: Call, req: Value, timeout: Duration) -> Result<Value, String> {
    let resp = call(req, timeout).map_err(|e| {
        format!("Cockpit is not running or unreachable. Open the Cockpit app and try again. (detail: {e})")
    })?;
    if resp.get("ok") == Some(&Value::Bool(true)) {
        Ok(resp.get("data").cloned().unwrap_or(Value::Null))
    } else {
        Err(transport::error_text(&resp))
    }
}

fn pretty(v: Value) -> String {
    serde_json::to_string_pretty(&v).unwrap_or_default()
}

fn format_messages(data: &Value, secs: u64) -> String {
    let msgs = data.as_array().map(Vec::as_slice).unwrap_or(&[]);
    if msgs.is_empty() {
        return format!("No messages after {secs}s. Call wait_messages again to keep waiting.");
    }
    let field = |m: &Value, k: &str| m.get(k).and_then(Value::as_str).unwrap_or("").to_string();
    let body: Vec<String> = msgs
        .iter()
        .map(|m| format!("[from: {} · {}] {}", field(m, "from"), field(m, "sentAt"), field(m, "text")))
        .collect();
    format!("{} message(s):\n\n{}", msgs.len(), body.join("\n\n"))
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::cell::RefCell;

    fn req(v: Value) -> Value {
        let mut v = v;
        v["jsonrpc"] = json!("2.0");
        v
    }

    #[test]
    fn initialize_ecoa_a_versao_e_anuncia_tools() {
        let none: Call = &|_, _| unreachable!();
        let r = handle(
            &req(json!({"id": 1, "method": "initialize", "params": {"protocolVersion": "2024-11-05"}})),
            "ext:cursor",
            "",
            none,
        )
        .unwrap();
        assert_eq!(r["id"], 1);
        assert_eq!(r["result"]["protocolVersion"], "2024-11-05");
        assert!(r["result"]["capabilities"]["tools"].is_object());
        assert_eq!(r["result"]["serverInfo"]["name"], "cockpit");
        let r = handle(&req(json!({"id": 2, "method": "initialize"})), "ext:cursor", "", none).unwrap();
        assert_eq!(r["result"]["protocolVersion"], PROTOCOL);
    }

    #[test]
    fn notificacao_nao_responde_e_metodo_desconhecido_e_erro() {
        let none: Call = &|_, _| unreachable!();
        assert!(handle(&req(json!({"method": "notifications/initialized"})), "ext:x", "", none).is_none());
        let r = handle(&req(json!({"id": "a", "method": "nope"})), "ext:x", "", none).unwrap();
        assert_eq!(r["error"]["code"], -32601);
        let r = handle(&req(json!({"id": 3, "method": "ping"})), "ext:x", "", none).unwrap();
        assert_eq!(r["result"], json!({}));
    }

    #[test]
    fn tools_list_tem_as_quatro_com_schema() {
        let none: Call = &|_, _| unreachable!();
        let r = handle(&req(json!({"id": 1, "method": "tools/list"})), "ext:x", "", none).unwrap();
        let tools = r["result"]["tools"].as_array().unwrap();
        let names: Vec<&str> = tools.iter().map(|t| t["name"].as_str().unwrap()).collect();
        assert_eq!(names, ["peers", "send", "wait_messages", "list_agents"]);
        assert!(tools.iter().all(|t| t["inputSchema"]["type"] == "object"));
        assert!(tools[1]["description"].as_str().unwrap().contains("wait_messages"));
    }

    #[test]
    fn send_vira_msg_com_o_emissor_externo() {
        let seen = RefCell::new(Vec::<Value>::new());
        let fake = |v: Value, _| {
            seen.borrow_mut().push(v);
            Ok(json!({"ok": true, "data": {"from": "ext:cursor", "to": "t3"}}))
        };
        let r = handle(
            &req(json!({"id": 9, "method": "tools/call",
                "params": {"name": "send", "arguments": {"to": "Reviewer", "text": "oi"}}})),
            "ext:cursor",
            "",
            &fake,
        )
        .unwrap();
        assert_eq!(
            seen.borrow()[0],
            json!({"cmd": "msg", "tabId": "ext:cursor", "args": {"to": "Reviewer", "text": "oi"}})
        );
        assert!(r["result"]["isError"].is_null());
        assert!(r["result"]["content"][0]["text"].as_str().unwrap().starts_with("Sent to t3"));
    }

    #[test]
    fn wait_limita_o_timeout_e_formata() {
        let seen = RefCell::new(Vec::<(Value, Duration)>::new());
        let fake = |v: Value, t| {
            seen.borrow_mut().push((v, t));
            Ok(json!({"ok": true, "data": [{"from": "Builder · Claude Code", "text": "pronto", "sentAt": "10:00"}]}))
        };
        let r = handle(
            &req(json!({"id": 1, "method": "tools/call",
                "params": {"name": "wait_messages", "arguments": {"timeout_seconds": 9999}}})),
            "ext:x",
            "",
            &fake,
        )
        .unwrap();
        let (v, t) = seen.borrow()[0].clone();
        assert_eq!(WAIT_MAX, 55, "cliente MCP do Claude Desktop corta em ~60s");
        assert_eq!(v["args"]["timeout"], WAIT_MAX);
        assert_eq!(t, Duration::from_secs(WAIT_MAX + 10));
        let text = r["result"]["content"][0]["text"].as_str().unwrap().to_string();
        assert_eq!(text, "1 message(s):\n\n[from: Builder · Claude Code · 10:00] pronto");
        assert_eq!(format_messages(&json!([]), 50), "No messages after 50s. Call wait_messages again to keep waiting.");
    }

    #[test]
    fn from_por_chamada_vai_pro_app_e_toda_tool_anuncia() {
        let none: Call = &|_, _| unreachable!();
        let r = handle(&req(json!({"id": 1, "method": "tools/list"})), "ext:x", "", none).unwrap();
        for t in r["result"]["tools"].as_array().unwrap() {
            assert_eq!(t["inputSchema"]["properties"]["from"]["type"], "string", "{}", t["name"]);
            assert!(t["description"].as_str().unwrap().contains("pass from: <your tab id>"));
        }
        // Um processo (daemon do Codex) servindo duas abas: cada chamada leva
        // a sua; sem `from`, só a identidade do startup (sem chave `from`).
        let seen = RefCell::new(Vec::<Value>::new());
        let fake = |v: Value, _| {
            seen.borrow_mut().push(v);
            Ok(json!({"ok": true, "data": []}))
        };
        let call = |name: &str, args: Value| {
            handle(
                &req(json!({"id": 1, "method": "tools/call", "params": {"name": name, "arguments": args}})),
                "ext:codex-desktop",
                "",
                &fake,
            )
        };
        call("wait_messages", json!({"from": "t50", "timeout_seconds": 0}));
        call("wait_messages", json!({"from": " Reviewer ", "timeout_seconds": 0}));
        call("peers", json!({"from": "t50"}));
        call("list_agents", json!({}));
        call("send", json!({"from": "t51", "to": "t50", "text": "oi"}));
        let s = seen.borrow();
        let w = |cmd: &str, args: Value| json!({"cmd": cmd, "tabId": "ext:codex-desktop", "args": args});
        assert_eq!(s[0], w("ext-wait", json!({"timeout": 0, "from": "t50"})));
        assert_eq!(s[1], w("ext-wait", json!({"timeout": 0, "from": "Reviewer"})));
        assert_eq!(s[2], w("peers", json!({"from": "t50"})));
        assert_eq!(s[3], w("agents", json!({})));
        assert_eq!(s[4], w("msg", json!({"to": "t50", "text": "oi", "from": "t51"})));
        // Erro do app (aba que não é Codex) volta como erro de ferramenta.
        let not_codex: Call = &|_, _| {
            Ok(json!({"ok": false, "error": "from: tab \"t3\" is not a Codex terminal tab"}))
        };
        let r = handle(
            &req(json!({"id": 2, "method": "tools/call",
                "params": {"name": "peers", "arguments": {"from": "t3"}}})),
            "ext:codex-desktop",
            "",
            not_codex,
        )
        .unwrap();
        assert_eq!(r["result"]["isError"], true);
        assert!(r["result"]["content"][0]["text"].as_str().unwrap().contains("not a Codex terminal tab"));
    }

    #[test]
    fn app_fora_do_ar_e_erro_de_ferramenta_claro() {
        let down: Call = &|_, _| Err("no Cockpit app to talk to".to_string());
        let r = handle(
            &req(json!({"id": 1, "method": "tools/call", "params": {"name": "peers"}})),
            "ext:x",
            "",
            down,
        )
        .unwrap();
        assert_eq!(r["result"]["isError"], true);
        assert!(r["result"]["content"][0]["text"]
            .as_str()
            .unwrap()
            .starts_with("Cockpit is not running"));
        let r = handle(
            &req(json!({"id": 2, "method": "tools/call", "params": {"name": "zzz"}})),
            "ext:x",
            "",
            down,
        )
        .unwrap();
        assert_eq!(r["error"]["code"], -32602);
    }

    #[test]
    fn agent_so_aceita_apps_conhecidos() {
        let a = |v: &[&str]| parse_agent(&v.iter().map(|s| s.to_string()).collect::<Vec<_>>());
        assert_eq!(a(&["--agent", "cursor"]), Ok(Some("cursor".into())));
        assert_eq!(a(&["--agent=codex-desktop"]), Ok(Some("codex-desktop".into())));
        assert!(a(&["--agent", "vim"]).is_err());
        assert_eq!(a(&[]), Ok(None));
    }

    #[test]
    fn schema_do_wait_tem_teto_55_e_default_45() {
        let none: Call = &|_, _| unreachable!();
        let r = handle(&req(json!({"id": 1, "method": "tools/list"})), "ext:x", "", none).unwrap();
        let wait = &r["result"]["tools"][2];
        assert_eq!(wait["inputSchema"]["properties"]["timeout_seconds"]["maximum"], 55);
        assert!(wait["description"].as_str().unwrap().contains("max 55; call again to keep waiting"));
        let seen = RefCell::new(Vec::<Value>::new());
        let fake = |v: Value, _| {
            seen.borrow_mut().push(v);
            Ok(json!({"ok": true, "data": []}))
        };
        handle(
            &req(json!({"id": 2, "method": "tools/call", "params": {"name": "wait_messages"}})),
            "t3",
            "",
            &fake,
        );
        assert_eq!(seen.borrow()[0], json!({"cmd": "ext-wait", "tabId": "t3", "args": {"timeout": 45}}));
    }

    #[test]
    fn identidade_aba_quando_o_app_acha_o_pid() {
        let seen = RefCell::new(Vec::<Value>::new());
        let app = |v: Value, _| {
            seen.borrow_mut().push(v);
            Ok(json!({"ok": true, "data": {"tabId": "t7", "label": "Builder"}}))
        };
        let me = resolve_identity(Some("codex-desktop"), Some("t7".into()), vec![4242, 4200], &app).unwrap();
        assert_eq!(me, Identity { tab: "t7".into(), label: "Builder".into(), external: false });
        assert_eq!(
            seen.borrow()[0],
            json!({"cmd": "mcp-whoami", "tabId": "t7", "args": {"pids": [4242, 4200]}})
        );
        // Sem env (Codex sem env_vars): só o pid viaja.
        resolve_identity(Some("codex-desktop"), None, vec![9], &app).unwrap();
        assert_eq!(seen.borrow()[1]["tabId"], Value::Null);
        assert!(instructions(&me).contains("terminal tab `Builder` (t7)"));
    }

    #[test]
    fn ancestrais_sobem_pela_tabela_do_ps() {
        // zsh(100) → codex(110) → cockpit mcp(120); 1 = init.
        let t = parse_ps("    1     0\n  100     1\n  110   100\n  120   110\n lixo\n");
        assert_eq!(chain(120, &t), [120, 110, 100, 1]);
        assert_eq!(chain(999, &t), [999], "fora da tabela: só o próprio pid");
        let ciclo = parse_ps("5 6\n6 5\n");
        assert_eq!(chain(5, &ciclo), [5, 6]);
        // O processo de verdade: a cadeia chega no próprio pai.
        let me = ancestry(std::process::id());
        assert_eq!(me[0], std::process::id());
        #[cfg(unix)]
        assert!(me.len() > 1, "{me:?}");
    }

    #[test]
    fn identidade_cai_no_externo_ou_erra_sem_agent() {
        let not_tab: Call = &|_, _| Ok(json!({"ok": false, "error": "not inside a Cockpit terminal"}));
        let me = resolve_identity(Some("codex-desktop"), None, vec![1], not_tab).unwrap();
        assert_eq!(
            me,
            Identity { tab: "ext:codex-desktop".into(), label: "codex-desktop".into(), external: true }
        );
        assert!(instructions(&me).contains("desktop agent `codex-desktop`"));
        assert!(resolve_identity(None, None, vec![1], not_tab).unwrap_err().contains("no --agent"));

        let down: Call = &|_, _| Err("connection refused".into());
        assert!(resolve_identity(Some("cursor"), Some("t1".into()), vec![1], down).unwrap().external);
        assert_eq!(resolve_identity(None, Some("t1".into()), vec![1], down).unwrap().tab, "t1");
        assert!(resolve_identity(None, None, vec![1], down).is_err());
    }
}
