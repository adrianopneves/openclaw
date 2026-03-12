# RUNBOOK-AGENTES

Guia rápido para operar o ambiente de multi-agentes no Mac mini do Adriano.

---
## 1. Onde vive o sistema

- Workspace principal: `/Users/adrianon/.openclaw/workspace`
- Documentação de arquitetura: `docs/arquitetura-multi-agentes-mission-control-v1.1.md`
- Change log de agentes: `docs/AGENTS_CHANGELOG.md`
- Segurança: `docs/openclaw-security.md`

---
## 2. Gateway e status geral

### Verificar status do OpenClaw

```bash
openclaw status
```

### Verificar status do gateway

```bash
openclaw gateway status
```

### Reiniciar gateway (quando necessário)

```bash
openclaw gateway restart
```

> Em caso de comportamento estranho persistente (integrações Google, e-mail, etc.), usar o script `~/openclaw-recover.sh` conforme descrito em `docs/openclaw-security.md`.

---
## 3. Operação dos agentes

### 3.1. Sessões/agentes principais

- **Pola** – Chief of Staff (sessão principal / esta conversa)
- **Vox** – LinkedIn / Conteúdo público
- **Sprint** – Execução / Notion
- Demais agentes conforme `docs/arquitetura-multi-agentes-mission-control-v1.1.md`.

### 3.2. Princípios operacionais

- Decisões de arquitetura/papel/autonomia de agentes devem ser registradas em `docs/AGENTS_CHANGELOG.md`.
- Alterações em SOUL/IDENTITY/AGENTS de agentes core (Pola, Vox, Sprint) são mudanças estruturais, não meros ajustes; registrar sempre.
- Heartbeats por agente devem seguir `HEARTBEAT.md` + instruções específicas de cada SOUL.

---
## 4. Mission Control

- Mission Control (Convex ou equivalente) é a **fonte única** de:
  - tarefas,
  - comentários/mensagens,
  - notificações/@mentions,
  - documentos/entregáveis.
- Qualquer automação de distribuição de tarefas entre agentes deve passar por Mission Control.

Detalhes de schema e fluxo em:
- `docs/arquitetura-multi-agentes-mission-control-v1.1.md` (seções 4 e 5)

---
## 5. Memória e arquivos

- Memória global (Pola): `MEMORY.md` + `memory/YYYY-MM-DD*.md`.
- Memória por agente (estado alvo):
  - `memory/WORKING_<Agente>.md`
  - `memory/YYYY-MM-DD_<Agente>.md`
  - `memory/MEMORY_<Agente>.md`

Regra: se algo precisa ser lembrado para decisões futuras, deve ir para arquivo (não apenas para o histórico de chat).

---
## 6. Rotina semanal recomendada

1. Revisar `docs/AGENTS_CHANGELOG.md` e arquitetura em `docs/arquitetura-multi-agentes-mission-control-v1.1.md`.
2. Verificar se o estado real dos agentes (pastas, SOULs, skills) bate com a arquitetura desenhada.
3. Limpar/organizar memórias em `memory/` (promover o que é estrutural para `MEMORY*.md`).
4. `git status`, `git commit` e `git push` para consolidar o estado como novo checkpoint.

---
## 7. Quando alterar esta RUNBOOK

Atualizar este arquivo quando:
- Novos agentes forem adicionados à operação.
- Mudarem os procedimentos de healthcheck/recover.
- For criada automação adicional (ex: scripts de cron, integrações novas).

Sempre que atualizar, registrar a mudança em `docs/AGENTS_CHANGELOG.md`.
