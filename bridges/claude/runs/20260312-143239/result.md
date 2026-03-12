TITLE: OpenClaw Environment Overview — Mac mini

EXEC_SUMMARY:
OpenClaw é um framework de orquestração de agentes de IA rodando localmente no seu Mac mini, que gerencia skills, bridges e um gateway para executar tarefas via Claude e outros modelos. Ele funciona como um middleware local que recebe inputs, roteia para o agente/skill correto, e devolve respostas estruturadas.

KEY_FINDINGS:
- **Gateway local**: `openclaw gateway` gerencia o ciclo de vida dos agentes e skills
- **Skills system**: cada skill tem um `SKILL.md` (metadata) + `bin/run` (executor), instaladas em `~/.openclaw/skills/`
- **Bridge Claude**: integração direta com o CLI `claude` via scripts shell em `~/.openclaw/workspace/bridges/claude/`
- **Run log**: cada execução gera um diretório datado em `.../bridges/claude/runs/<timestamp>/` com `request.txt`, `result.md`, `debug.log`
- **Modo de detecção**: o skill `claude-bridge` detecta automaticamente o modo (linkedin, twinmind, notion, web, pdf, strategy) pelo conteúdo do input

NEXT_STEPS:
1. Verificar se `openclaw gateway restart` completou sem erros
2. Testar o skill instalado: `echo "teste" | ~/.openclaw/skills/claude-bridge/bin/run`
3. Conferir logs em `~/.openclaw/workspace/bridges/claude/runs/latest/debug.log` se houver falha

FULL_ANALYSIS:
O OpenClaw no seu Mac mini é uma plataforma de agentes AI local composta por três camadas:

**1. Gateway/Runtime** — processo daemon (`openclaw gateway`) que gerencia agents registrados e roteia mensagens entre eles e as skills.

**2. Skills** — unidades de execução isoladas. Cada skill é um diretório com spec (`SKILL.md`) e um binário executável (`bin/run`). O gateway descobre e expõe skills automaticamente. A skill `claude-bridge` recém-instalada aceita texto via stdin, detecta o modo pelo conteúdo, e delega ao bridge do Claude.

**3. Bridges** — integrações com ferramentas externas. O bridge do Claude (`claude_bridge.sh`) formata o prompt com modo e formato de saída obrigatório, chama `~/bin/run-claude.sh` (que invoca o CLI `claude --print`), persiste o resultado, e extrai o resumo estruturado.

O fluxo completo: `openclaw agent` → skill `claude-bridge` → `claude_bridge.sh` → `run-claude.sh` → CLI `claude` → resultado estruturado de volta ao agente.
