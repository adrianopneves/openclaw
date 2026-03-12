# Arquitetura Geral do Sistema de Adriano (v1.0)

> Versão 1.0 — Março 2026  
> Ambiente: Mac mini do Adriano / OpenClaw + Squad de Agentes + Mission Control + Ferramentas externas

Este documento consolida a **arquitetura geral** hoje implementada (ou em implementação) no teu ecossistema:

- OpenClaw como "cérebro operacional" rodando em Mac mini
- Squad de agentes (Pola, Vox, Sprint, etc.) como sessões independentes
- Mission Control como plano central de tarefas/comunicação entre agentes
- Ferramentas externas integradas: Buffer/LinkedIn, Notion, Google (Gmail, Calendar), outros

A ideia é servir como **fonte de verdade** para evoluções, novos agentes e novas integrações.

---

## 1. Visão em Camadas

Arquitetura em 4 camadas principais:

1. **Camada de Infraestrutura & Runtime**
   - Mac mini com OpenClaw Gateway 24/7
   - Scripts de healthcheck e recuperação
   - Gestão de segredos e segurança do host

2. **Camada de Inteligência (Agentes)**
   - Squad de ~10 agentes, cada um com identidade, SOUL, memória e escopo
   - Pola como Chief of Staff e orquestrador humano-facing

3. **Camada de Coordenação (Mission Control)**
   - Backend central (Convex ou similar) para tasks, mensagens, documentos e notificações

4. **Camada de Ferramentas & Canais Externos**
   - Buffer/LinkedIn (conteúdo público)
   - Notion (Second Brain / PARA)
   - Google (Gmail, Calendar)
   - Outros serviços conforme forem entrando

Diagrama conceitual (texto):

```text
[ Adriano ]
    |
  (Pola - Chief of Staff)
    |
[ OpenClaw Runtime no Mac mini ]
    |
    +-- Squad de Agentes (Pola, Vox, Sprint, Agenda, Inbox, ...)
    |        |
    |        +-- Acessam Mission Control (tasks, messages, docs)
    |
    +-- Skills/Integrações
             |
             +-- Buffer -> LinkedIn
             +-- Gog -> Gmail / Calendar
             +-- Notion Skill -> Notion (PARA)
             +-- Outros (a definir)
```

---

## 2. Camada de Infraestrutura & Runtime

### 2.1. Host e OpenClaw

- **Host:** Mac mini dedicado
- **OpenClaw Gateway:** instalado como serviço, rodando 24/7
- **Workspace:** `/Users/adrianon/.openclaw/workspace`
  - `AGENTS.md`, `SOUL.md`, `USER.md`, `IDENTITY.md`
  - `docs/` com arquitetura, segurança, checklists
  - `memory/` com logs diários e memória de longo prazo
  - `agents/` com identidades específicas por agente

### 2.2. Operação e Saúde

- **Scripts principais** (ver `openclaw-security.md` + `openclaw-update-checklist.md`):
  - `openclaw-healthcheck.sh`: roda via cron a cada ~5 minutos para validar gateway + integrações críticas (ex: gog)
  - `openclaw-recover.sh`: playbook rápido de recuperação (restart gateway, doctor, etc.)

- **Segurança:**
  - FileVault + autenticação forte
  - Segredos em `.env` / configs locais, nunca em chat/git
  - Rotação de tokens se algo vazar para logs ou chat

---

## 3. Camada de Inteligência (Squad de Agentes)

### 3.1. Squad atual planejado

Conforme `MEMORY.md` e `arquitetura-multi-agentes-mission-control-v1.1.md`:

- **Pola** – Chief of Staff (sessão principal, interface com Adriano)
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

- Tem pasta em `agents/<nome>/` com `SOUL.md` e arquivos auxiliares (IDENTITY/USER específicos se necessário).
- Usa **memória em arquivos**:
  - `memory/WORKING_<Agente>.md` (estado atual)
  - `memory/YYYY-MM-DD_<Agente>.md` (log diário)
  - `memory/MEMORY_<Agente>.md` (memória de longo prazo)
- Interage com Mission Control para tarefas, comentários e documentos.
- Tem níveis de autonomia (1–3), inicialmente conservadores (sem publicação automática externa).

### 3.2. Papel de Pola

- É o **Chief of Staff** e agente principal desta sessão.
- Funções:
  - Filtrar ruído e trazer clareza para Adriano.
  - Orquestrar outros agentes (via Mission Control e sessões).
  - Garantir que a arquitetura e o modelo operacional evoluam de forma coerente.

---

## 4. Camada de Coordenação (Mission Control)

Mission Control é o **hub central** de coordenação, pensado em cima de Convex (ou backend equivalente) com as entidades:

- `agents`: registro de agentes, status, sessão
- `tasks`: unidades de trabalho com dono(s) e estado
- `messages`: conversas em torno de tasks com @mentions
- `documents`: entregáveis, pesquisas e protocolos ligados a tasks
- `activities`: feed de eventos (task criada, status mudado, doc gerado)
- `notifications`: ponte entre @mentions e sessões dos agentes

### 4.1. Fluxo padrão de trabalho entre agentes

1. **Criação de tarefa**
   - Task criada no Mission Control (por Adriano via Pola, ou por outro agente).

2. **Atribuição**
   - `assigneeIds` são definidos (ex: Vox + Sprint).

3. **Execução**
   - Agentes pegam tasks em heartbeats ou quando notificados.
   - Progresso é logado em `messages` + `documents`.

4. **Notificações**
   - `@AgentName` gera entrada em `notifications`.
   - Um daemon entrega essas notificações via `sessions_send` para a sessão do agente.

5. **Conclusão**
   - Task vai para `review` e depois `done`.
   - Documentos finais ficam associados à task como fonte de verdade.

### 4.2. Heartbeats por agente

- Cada agente tem um heartbeat periódico (cron), com horários defasados.
- Em cada heartbeat, o agente:
  1. Lê arquivos de memória relevantes.
  2. Checa Mission Control (tasks, notificações, atividades).
  3. Age (trabalha, atualiza estado, escreve memória) ou responde `HEARTBEAT_OK` se nada for necessário.

---

## 5. Camada de Ferramentas & Canais Externos

### 5.1. Buffer & LinkedIn (Conteúdo Público)

- **Objetivo:** permitir que agentes (principalmente **Vox** e **Pola**) agendem e gerenciem posts no LinkedIn com segurança e rastreabilidade.

- **Componentes:**
  - Skill `buffer-list-channels`: lista organizações/canais conectados ao Buffer.
  - Skill `linkedin-schedule-post`: agenda posts no LinkedIn via Buffer.

- **Fluxo típico:**

```text
Adriano → Pola (ideia de post)
    → Pola/Vox estruturam texto
        → Skill linkedin-schedule-post
            → Buffer
                → LinkedIn (post agendado)
```

- **Decisões de arquitetura:**
  - Buffer funciona como **camada intermediária** entre agentes e LinkedIn (nenhum agente fala direto com a API do LinkedIn).
  - Primeiro estágio de autonomia: posts sempre começam como **rascunho** ou com validação explícita antes de publicar.

### 5.2. Notion (Second Brain / PARA)

- **Objetivo:** organizar projetos, áreas, recursos e arquivos em um único sistema (Notion) que agentes possam ler/escrever.

- **Componentes:**
  - Skill `notion` (via Notion API) – usado por agentes como **Sprint** e **Notion Brain**.

- **Fluxos típicos:**
  - **Sprint**: criar/atualizar páginas de projeto, status, checklists.
  - **Notion Brain**: manter a arquitetura PARA coerente (Projects, Areas, Resources, Archives) e refatorar estruturas.

- **Modelo mental:**
  - Mission Control é o **hub de execução** (tasks, mensagens, docs).
  - Notion é o **repositório estruturado** de conhecimento e projetos.
  - Agentes sincronizam os dois: uma task gera/atualiza páginas em Notion quando faz sentido.

### 5.3. Google (Gmail, Calendar) – via `gog`

- **Objetivo:** permitir que agentes **Inbox** e **Agenda** operem caixa de entrada e calendário.

- **Componentes:**
  - Skill `gog`: CLI para Gmail, Calendar, Drive, etc.

- **Fluxos típicos:**
  - **Inbox**: ler e priorizar e-mails, propor respostas, marcar follow-ups (respeitando limites de autonomia).
  - **Agenda**: checar compromissos, propor blocos de foco, alertar sobre conflitos.

- **Integração com heartbeats:**
  - Healthcheck (via scripts) valida acesso ao Google regularmente.
  - Agentes usam `gog` em heartbeats para fazer varreduras leves (novos e-mails importantes, eventos próximos, etc.).

---

## 6. Cadências Operacionais

### 6.1. Cadências de Conteúdo (Vox + Pola)

- **Semanalmente**:
  - Criar 3–5 novas tasks de ideia de post em Mission Control.
  - Garantir pelo menos 2 posts em rascunho e 1–2 prontos para agendar.
  - Revisão em bloco por Pola (ajuste de tom e alinhamento estratégico).
- **Mensalmente**:
  - Gerar um mini-relatório de conteúdo (posts publicados, temas fortes, oportunidades de aprofundar).

### 6.2. Cadências de Sistema (Pola + Sprint + Notion Brain + Agenda)

- **Semanal**:
  - Sprint: revisão de projetos ativos em Notion + Mission Control.
  - Agenda: revisão da próxima semana (conflitos, blocos de foco sugeridos).
  - Pola: consolidar um resumo curto para Adriano (principais frentes e pendências).
- **Mensal**:
  - Revisão da arquitetura geral e atualização de documentos-chave.
  - Revisão dos níveis de autonomia por agente.

---

## 7. Roadmap da Arquitetura Geral

Conectando com o roadmap multi-agentes já definido:

- **Fase 0** – Arquitetura geral documentada (este arquivo) + inventário de agentes e integrações.
- **Fase 1** – Operação guiada de 3 agentes core (Pola, Vox, Sprint) usando:
  - Mission Control para tasks
  - Notion como repositório de projetos
  - Buffer/LinkedIn via skills, sem autonomia total
- **Fase 2** – Heartbeats ativos para Vox, Sprint, Agenda, Inbox:
  - Sugestões de ações (posts, follow-ups, blocos de foco), sem envio automático.
  - Atualizações no Mission Control e Notion.
- **Fase 3** – Integração plena Mission Control ↔ Notion ↔ Canais externos:
  - Tasks em Mission Control espelham projetos/itens relevantes em Notion.
  - Estados e entregáveis visíveis em um único lugar.
- **Fase 4** – Autonomia seletiva:
  - Vox e Sprint com autonomia nível 2–3 em contextos específicos (ex: publicar posts de um certo tag sem aprovação, responder e-mails de um tipo, etc.).

---

## 7. Como Evoluir este Documento

- Este arquivo (`docs/arquitetura-geral-sistema-v1.0.md`) é a **fonte de verdade da visão macro**.
- O arquivo `docs/arquitetura-multi-agentes-mission-control-v1.1.md` é o **zoom** na arquitetura de agentes + Mission Control.

Sempre que:

- um novo canal/integração for adicionado (ex: WhatsApp, Slack, CRM),
- novos agentes entrarem em operação ou mudarem de papel,
- o modelo de autonomia for alterado,

este documento deve ser atualizado (v1.1, v1.2, etc.), mantendo o histórico de versões e decisões.

Pola deve usar este documento como mapa para:

- propor novos fluxos,
- decidir onde encaixar novas capacidades,
- explicar o sistema para terceiros (time, parceiros, etc.) com consistência.
