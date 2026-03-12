---

**TITLE:** OpenClaw — Plataforma de Agentes AI com Interface via Telegram no Mac mini

---

**EXEC_SUMMARY:**
OpenClaw é uma plataforma local de automação por agentes AI que roda no seu Mac mini, exposta via bot Telegram. Mensagens enviadas ao bot disparam agentes (primário: GPT-5.1 via OpenAI Codex) que executam tarefas com acesso a ferramentas, skills e integrações externas.

---

**KEY_FINDINGS:**

| Componente | Detalhe |
|---|---|
| **Runtime** | Node.js 22+, processo local no Mac mini |
| **Interface** | Bot Telegram (`dmPolicy: open`, `groupPolicy: allowlist`) |
| **Modelos AI** | Primary: `openai-codex/gpt-5.1` · Fallbacks: OpenRouter auto/free |
| **Gateway** | HTTP local porta `18789`, auth por token, bind `loopback` |
| **Agentes** | Até 4 concorrentes, 8 subagentes, workspace em `~/.openclaw/workspace` |
| **Skills ativas** | Notion, Clawhub (`clawhub.ai`), Tavily (web search), GOG, nano-banana-pro |
| **MCP Server** | `~/openclaw-mcp-server` — expõe OpenClaw como ferramenta MCP (ex: para Claude) |
| **Confiabilidade** | 5 LaunchAgents: gateway, watchdog, buffer-watchdog, social-canary, social-backup |
| **Versão** | `2026.3.7` (última atualização: 2026-03-09) |

---

**NEXT_STEPS:**

1. **Verificar saúde atual** — checar `openclaw-healthcheck.log` e status dos LaunchAgents
2. **Auditar skills** — `gh-issues` e `goplaces` estão desabilitadas; avaliar se são necessárias
3. **Segurança** — o `botToken` e chaves de API estão em plain text em `~/.openclaw/openclaw.json`; considerar vault ou variáveis de ambiente criptografadas

---

**FULL_ANALYSIS:**

O **OpenClaw** é um runtime de agentes AI que você hospeda localmente no Mac mini. Sua arquitetura:

- **Canal de entrada:** Bot do Telegram recebe mensagens → OpenClaw roteia para o agente `main` (binding `channel: telegram`)
- **Motor de execução:** Agentes AI com modelo primário GPT-5.1, compaction em modo `safeguard`, e concorrência controlada
- **Skills/Ferramentas:** Sistema extensível de plugins — Telegram é um plugin interno; skills externas como Notion e Tavily expandem as capacidades dos agentes
- **Resiliência:** Múltiplos LaunchAgents garantem auto-restart do gateway e watchdogs monitoram buffer e saúde do processo
- **MCP Bridge:** O `openclaw-mcp-server` permite que ferramentas como Claude Code se conectem ao OpenClaw como servidor MCP, criando um loop onde Claude pode acionar agentes OpenClaw e vice-versa
- **Versão estável:** Canal `stable` com auto-update ativado, última versão `2026.3.7`

Em resumo: você tem um **assistente AI pessoal sempre online**, controlado pelo Telegram, com acesso a web, Notion, e capacidade de executar tarefas complexas com múltiplos subagentes em paralelo.
