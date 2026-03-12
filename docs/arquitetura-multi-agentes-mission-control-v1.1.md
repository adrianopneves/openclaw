# Arquitetura Multi-Agentes com OpenClaw – Mission Control (v1.1)

> Versão 1.1 — Março 2026  
> Ambiente: Mac mini do Adriano / OpenClaw com Pola como Chief of Staff

Este documento consolida a arquitetura da solução de multi-agentes, Mission Control e modelo de segurança/operacional adotados no ambiente do Adriano.

---

## 1. Objetivo do Sistema

Ter um **squad de ~10 agentes** de IA operando como um time real, com:

- Sessões persistentes por agente, cada uma com identidade (SOUL), memória e papéis claros.
- Um **Mission Control** centralizado (Convex ou similar) como fonte única de:
  - tarefas,
  - comentários/mensagens,
  - documentos/entregáveis,
  - notificações/@mentions entre agentes.
- Heartbeats periódicos (cron) por agente, permitindo trabalho contínuo mesmo sem interação direta.
- Daily standup automático com resumo de atividades, bloqueios e decisões do dia.
- Modelo de segurança explícito e scripts operacionais para estabilidade.

---

## 2. Squad de Agentes (vista atual)

Squad planejado (ref. MEMORY.md):

- **Pola** – Chief of Staff (sessão principal, você está aqui)
- **Vox** – LinkedIn / Conteúdo público
- **Sprint** – Execução / Notion (projetos e tarefas)
- **North Star** – Estratégia / Direção
- **Storyline** – Apresentações e narrativas visuais
- **Inbox** – E-mails / Mensagens
- **Agenda** – Calendário / Energia
- **Notion Brain** – Arquitetura Notion / PARA
- **Deals** – Pipeline / Oportunidades
- **Research** – Pesquisa / Radar

Cada agente:
- Tem pasta em `agents/<nome>/` com `SOUL.md`, `IDENTITY.md`/`USER.md` específicos se necessário.
- Trabalha com memória em arquivos dentro do workspace principal (ver seção 3).
- Usa Mission Control para tarefas e comunicação estruturada.

---

## 3. Memória e Arquivos (modelo geral)

### 3.1. Estrutura recomendada

Dentro do workspace do OpenClaw:

```plaintext
/Users/adrianon/.openclaw/workspace
├── AGENTS.md                # Manual para todos os agentes (Pola, Vox, Sprint, etc.)
├── SOUL.md                  # SOUL de Pola (Chief of Staff)
├── agents/
│   ├── vox/
│   ├── sprint/
│   ├── agenda/
│   └── ...                  # Pastas com SOUL/IDENTITY de cada agente
├── memory/
│   ├── YYYY-MM-DD.md        # Notas diárias globais (Pola)
│   ├── YYYY-MM-DD-*.md      # Sessões/temas específicos
│   └── ...
└── docs/
    ├── arquitetura-multi-agentes-mission-control-v1.1.md
    ├── openclaw-security.md
    └── openclaw-update-checklist.md
```

Para o modelo multi-agentes completo, a ideia é evoluir para algo próximo de:

```plaintext
memory/
  WORKING_<Agente>.md         # Estado de trabalho atual por agente
  YYYY-MM-DD_<Agente>.md      # Log cronológico por agente
  MEMORY_<Agente>.md          # Memória de longo prazo por agente
```

Regra de ouro codificada nas SOULs:
> Se algo precisa ser lembrado, escreva em arquivo. Não confie em "mental notes".

---

## 4. Mission Control (Convex ou equivalente)

Mission Control é o "escritório compartilhado" onde agentes coordenam trabalho.

### 4.1. Esquema lógico de dados

Entidades principais (inspiradas no modelo do Bhanu Teja):

- `agents`
  - `id`, `name`, `role`, `status` ("idle" | "active" | "blocked"), `currentTaskId`, `sessionKey`.
- `tasks`
  - `id`, `title`, `description`, `status` ("inbox" | "assigned" | "in_progress" | "review" | "done" | "blocked"), `assigneeIds` (lista de agentIds), timestamps.
- `messages`
  - `id`, `taskId`, `fromAgentId`, `content`, `attachments` (lista de `documents`), timestamp.
- `activities`
  - `id`, `type` ("task_created" | "message_sent" | "document_created" | ...), `agentId`, `taskId`, `message`, timestamp.
- `documents`
  - `id`, `title`, `content` (Markdown), `type` ("deliverable" | "research" | "protocol" | ...), `taskId`, timestamp.
- `notifications`
  - `id`, `mentionedAgentId`, `content`, `delivered` (bool), timestamp.

### 4.2. Fluxo de uso

- **Tasks**: criadas, atribuídas, movidas de estado apenas via Mission Control.
- **Mensagens**: discussão de task acontece em `messages`, com `@mentions` para notificar agentes.
- **Documents**: entregáveis e pesquisas anexados a tasks.
- **Activities**: feed em tempo real do que está acontecendo.
- **Notifications**: ponte entre mentions e agentes (via sessions do OpenClaw).

---

## 5. Comunicação entre Agentes

Dois modos, com preferência pelo Mission Control:

1. **Modo principal – Mission Control**
   - Agentes interagem via tasks, messages e notifications.
   - `@AgentName` e `@all` geram registros em `notifications`.
   - Um daemon lê `notifications` não entregues e dispara mensagens para as sessões dos agentes via `sessions_send`.

2. **Modo secundário – sessão direta**
   - `sessions_send` direto entre sessões para casos especiais.
   - Uso restrito; preferir sempre que o histórico fique registrado no Mission Control.

---

## 6. Heartbeats e Ciclo de Vida

### 6.1. Heartbeat por agente

Cada agente terá um heartbeat periódico (idealmente a cada ~15 minutos), com horários defasados para evitar picos.

No heartbeat, o agente deve:

1. **Carregar contexto**
   - Ler `WORKING_<Agente>.md`.
   - Se necessário, ler `YYYY-MM-DD_<Agente>.md` do dia.
   - Consultar `MEMORY_<Agente>.md` para fatos de longo prazo.

2. **Checar Mission Control**
   - Notificações / @mentions pendentes.
   - Tasks com status `assigned` ou `in_progress` para aquele agente.
   - Activity feed por discussões relevantes.

3. **Agir**
   - Se há trabalho: executar, atualizar arquivos de memória e Mission Control.
   - Se não há nada: responder apenas `HEARTBEAT_OK` e encerrar.

### 6.2. HEARTBEAT.md global

O `HEARTBEAT.md` na raiz do workspace define o comportamento padrão em heartbeats para o ambiente como um todo. Agentes individuais podem ter instruções adicionais específicas nas suas SOULs ou arquivos de heartbeat dedicados.

---

## 7. Segurança e Operação

O modelo de segurança completo está detalhado em `docs/openclaw-security.md`. Pontos-chave:

- **Identidade e acesso**
  - Separação entre conta pessoal e contas/integrações de assistente.
  - Acesso seguro ao Mac mini, com FileVault e autenticação forte.

- **Gestão de segredos**
  - Uso de `.env` e configs locais, nunca expondo tokens em chat ou git.
  - Rotação obrigatória sempre que algum segredo vazar para chat/log.

- **Host (Mac mini)**
  - OpenClaw instalado via instalador oficial.
  - Gateway rodando como LaunchAgent (24/7).

- **Scripts operacionais**
  - `~/openclaw-healthcheck.sh`: healthcheck de gateway + Gmail/Calendar via gog, rodando a cada 5 minutos via `cron`.
  - `~/openclaw-recover.sh`: recuperação rápida (status, restart de gateway, doctor, probes e testes de gog).

- **Autonomia dos agentes**
  - Níveis 1–3 por agente, começando com níveis conservadores (sem publicação externa automática).

---

## 8. Roadmap Multi-Agentes (resumo)

Conforme `MEMORY.md` e `OPENCLAW-ROADMAP.md`:

- **Fase 0** — Inventário de agentes, papéis, rotinas semanais, limites claros (sem overlap desnecessário entre Vox/Sprint/Notion Brain, etc.).
- **Fase 1** — Operação guiada de 3 agentes core (Pola, Vox, Sprint) sem autonomia externa, focando em conteúdo, projetos e orquestração.
- **Fase 2** — Heartbeats leves por agente (Vox, Sprint, Agenda), apenas sugerindo ações e atualizando Mission Control; nada é publicado/enviado sozinho.
- **Fase 3** — Integração plena com Mission Control (Convex) como fonte única de tarefas, estado e comentários.
- **Fase 4** — Autonomia gradual por agente (níveis 1–3) com guardrails claros, começando por Vox/Sprint.

Itens de infraestrutura pendentes:
- Schema final do Mission Control em Convex (ou backend escolhido) + migração de qualquer MVP em SQLite/JSON para ele.
- Skill/integração com Buffer em modo rascunho.
- Identidades/pastas completas por agente, com SOUL/AGENTS/HEARTBEAT específicos.
- Definição detalhada de heartbeats (cron) e níveis de autonomia por agente.

---

## 9. Como este documento deve ser usado

- Referência principal para decisões de:
  - criação de novos agentes,
  - definição de papéis/responsabilidades,
  - fluxo de tarefas e comunicação,
  - integração com Mission Control,
  - segurança e operação.

- Sempre que:
  - um novo agente for criado,
  - o Mission Control mudar (schema, backend),
  - o modelo de segurança for alterado,
  este documento deve ser atualizado para refletir a arquitetura vigente.

Pola deve usar este arquivo como "mapa" sempre que for discutir ou propor mudanças na arquitetura multi-agentes.