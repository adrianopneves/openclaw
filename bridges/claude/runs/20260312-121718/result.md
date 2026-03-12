---

**TITLE:**
OpenClaw — Gateway de Automação Multi-Agente via Telegram no Mac mini (adrianon)

---

**EXEC_SUMMARY:**
O OpenClaw é um gateway de IA multi-canal instalado localmente no Mac mini, usando o Telegram como interface principal de controle. Ele orquestra múltiplos agentes especializados, integra Buffer/LinkedIn para automação de redes sociais, e roda como serviços permanentes via `launchd`. O sistema está saudável e operacional.

---

**KEY_FINDINGS:**

| # | Componente | Detalhe |
|---|-----------|---------|
| 1 | **Gateway** | Node.js rodando em `ws://127.0.0.1:18789`, sempre ativo via LaunchAgent `ai.openclaw.gateway` |
| 2 | **Bot Telegram** | `@OpenClaw_APN_Bot` — canal de entrada de comandos, modo polling |
| 3 | **Agente principal** | `pola` (Chief of Staff) — roteado do canal Telegram, policy DM=open, grupos=allowlist |
| 4 | **Agentes especializados** | `inbox`, `research`, `storyline`, `notion_brain`, `deals`, `vox`, `gamma` |
| 5 | **Automação social** | Buffer GraphQL API + LinkedIn — posting agendado, fila monitorada |
| 6 | **Skills instaladas** | `buffer-social`, `linkedin-schedule-post`, `ask-claude`, `notion-skill`, `tavily-search`, `screen-capture` |
| 7 | **MCP Server** | `/Users/adrianon/openclaw-mcp-server` — bridge para Claude Code |
| 8 | **Monitoramento** | 5 LaunchAgents: gateway, 2x watchdog (5 min), canary diário (7h), backup diário (6h15) |
| 9 | **Logs** | `~/.openclaw/logs/` — gateway.log (548KB), erros (1.5MB), watchdog (42KB) |
| 10 | **Modelo AI** | Primary: `gpt-5.1` via OpenRouter, com fallbacks free tier |

---

**NEXT_STEPS:**

1. **Auditoria de segredos** — Bot token, Buffer token e Gateway auth estão em plain text em `~/.openclaw/openclaw.json` e `env/social.env`. Considere mover para macOS Keychain ou variáveis de ambiente seguras.
2. **Rotação de tokens** — Gateway auth token hardcoded (`4e9799f3...`). Boas práticas sugerem rotação periódica.
3. **Limpeza de logs** — `gateway.err.log` com 1.5MB pode indicar erros recorrentes que merecem investigação.
4. **Documentação dos agentes** — Com 7+ agentes especializados, vale consolidar os `OPERATIONS.md` e `IDENTITY.md` por agente.
5. **Backup offsite** — Backups diários locais (14 dias de retenção) em `~/.openclaw/backups/` — considere sync para iCloud ou S3.

---

**FULL_ANALYSIS:**

```
ARQUITETURA GERAL
─────────────────
[Telegram] ──→ @OpenClaw_APN_Bot
                    │
                    ↓
     ┌──────────────────────────────┐
     │  OpenClaw Gateway :18789     │  ← LaunchAgent (always-on)
     │  /Users/adrianon/openclaw    │
     │  versão 2026.3.7             │
     └───────────┬──────────────────┘
                 │
     ┌───────────┴────────────────────────┐
     │                                    │
     ▼                                    ▼
┌─────────────────┐           ┌───────────────────────┐
│  Agente "pola"  │           │  Automação Social     │
│  (Chief of      │           │  Buffer GraphQL API   │
│   Staff)        │           │  LinkedIn Channel     │
│                 │           │  Org: 69ad8eb4...     │
│  Sub-agentes:   │           └───────────┬───────────┘
│  - inbox        │                       │
│  - research     │         ┌─────────────┴──────────┐
│  - storyline    │         │                        │
│  - notion_brain │         ▼                        ▼
│  - deals        │   buffer.com API          LinkedIn API
│  - vox / gamma  │   (post, schedule,        (via wrapper)
└─────────────────┘    queue, analytics)

LAUNCHAGENTS ATIVOS (launchd)
──────────────────────────────
• ai.openclaw.gateway         → sempre ativo, reinicia auto
• ai.openclaw.buffer.watchdog → a cada 5 min
• ai.openclaw.social.watchdog → a cada 5 min  
• ai.openclaw.social.canary   → diário 07:00
• ai.openclaw.social.backup   → diário 06:15

FLUXO DE COMANDO VIA TELEGRAM
───────────────────────────────
Usuário envia msg → Bot recebe → Gateway roteia para agente "main" (pola)
→ Pola interpreta e executa skill → Responde no Telegram

MEMÓRIA PERSISTENTE
────────────────────
~/.openclaw/workspace/memory/
├── procedural/   → PLAYBOOK, STRATEGY
├── semantic/     → AGENTS-ARCHITECTURE, LINKEDIN-STRATEGY
└── 50+ sessões   → Logs de memória desde 2026-03-07

STATUS ATUAL (2026-03-12)
──────────────────────────
Gateway PID: 31736          ✅ RUNNING
Telegram bot:               ✅ CONNECTED
Buffer account:             ✅ OK
LinkedIn channel:           ✅ FOUND
Queue system:               ✅ OPERATIONAL
Último restart gateway:     09:01:30
Último watchdog health:     12:17 (passou)
```

O sistema é robusto, auto-recuperável e bem monitorado. O principal risco atual é a gestão de segredos em plain text.
