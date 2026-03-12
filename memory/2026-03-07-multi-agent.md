# Session: 2026-03-07 11:46:42 UTC

- **Session Key**: agent:main:main
- **Session ID**: 4aaf3933-6443-4b12-9028-fd00f9326c3b
- **Source**: webchat

## Conversation Summary

assistant: [[reply_to_current]] Se eu pudesse clicar aí por você, eu já tinha feito 😅  
Mas daqui eu **não consigo mexer na sua tela nem colar o token** — só te guiar.

Vamos fazer assim, bem mastigado. Me responde **1 coisa primeiro**:

Na esquerda da tela do OpenClaw Web, o que você vê no menu? Algo tipo:

- `Sessions`
- `Agents`
- `Settings`
- `Channels`
- `Gateway`
- `Integrations`

Copia pra mim os nomes exatos das opções do menu lateral que aparecem aí.  
Com isso eu te falo: “clica em X → depois em Y → cola o token aqui”.

Enquanto isso, se quiser já ir adiantando, faz isso no terminal:

```bash
openclaw gateway status
```

E me manda o resultado também.
user: Sender (untrusted metadata):
```json
{
  "label": "openclaw-control-ui",
  "id": "openclaw-control-ui"
}
```

[Fri 2026-03-06 07:39 GMT-3] openclaw pairing approve telegram Q3J4BZ7S
assistant: [[reply_to_current]] Perfeito, você já aprovou o pareamento do Telegram com:

```bash
openclaw pairing approve telegram Q3J4BZ7S
```

Agora são só mais dois passos:

---

### 1. Garantir que o gateway tá rodando

No terminal, roda:

```bash
openclaw gateway status
```

Se **não** estiver `running`, inicia:

```bash
openclaw gateway start
```

---

### 2. Testar o bot

No Telegram:

1. Abre `@PolaAgentic_bot`.
2. Clica em **Start**.
3. Manda uma mensagem tipo:  
   `Pola, to testando você no OpenClaw`

Na interface web do OpenClaw, deve aparecer **uma nova sessão/chat** vindo do Telegram.

Me fala:

- O que deu no `openclaw gateway status`  
- Se a mensagem que você mandou no bot apareceu aí na lista de sessões.
user: Sender (untrusted metadata):
```json
{
  "label": "openclaw-control-ui",
  "id": "openclaw-control-ui"
}
```

[Fri 2026-03-06 08:20 GMT-3] usar material abaixo para criar um modelo de multi agente, avalie best practices e crie um para nos Vou montar um “pacote de especificação” em português, pronto para você colar no OpenClaw como pedido de projeto de multi‑agentes inspirado no Mission Control do Bhanu Teja. [x](https://x.com/pbteja1998/status/2017662163540971756)

***

## 1. Objetivo do sistema

Quero que você implemente, usando OpenClaw, um sistema de multi‑agentes persistentes inspirado no “Mission Control” descrito por Bhanu Teja, onde ~10 agentes de IA funcionam como um time real, com:

- Sessões persistentes por agente (memória e contexto próprios). [x](https://x.com/pbteja1998/status/2017662163540971756)
- Um “escritório compartilhado” (Mission Control) com banco de dados de tarefas, mensagens, documentos e notificações. [x](https://x.com/pbteja1998/status/2017662163540971756)
- Heartbeats via cron a cada 15 minutos para cada agente checar trabalho, notificações e continuar o que estava fazendo. [x](https://x.com/pbteja1998/status/2017662163540971756)
- Daily standup gerado automaticamente com resumo do dia. [x](https://x.com/pbteja1998/status/2017662163540971756)

Você deve propor a arquitetura, arquivos de configuração e exemplos de comandos para que eu possa subir isso em produção.

***

## 2. Arquitetura geral com OpenClaw

### 2.1 Gateway

- Rodar o gateway do OpenClaw como daemon 24/7, com:
 - Configuração JSON definindo: provedor de modelo (Anthropic/OpenAI), canais (por enquanto só CLI/HTTP; depois Telegram/Slack), ferramentas (filesystem, shell, HTTP, browser) e workspace root. [x](https://x.com/pbteja1998/status/2017662163540971756)
- Comando base esperado:
 - `clawdbot gateway start` (ou equivalente no OpenClaw atual). [x](https://x.com/pbteja1998/status/2017662163540971756)

### 2.2 Sessões / agentes

- Cada agente é uma sessão OpenClaw independente, com:
 - `sessionKey` única (ex: `agent:main:main`, `agent:product-analyst:main`, etc.). [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Histórico armazenado em JSONL no filesystem. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Ferramentas e modelo configurados por sessão. [x](https://x.com/pbteja1998/status/2017662163540971756)
- As sessões precisam suportar dois modos:
 - Sessão principal (interativa e de longa duração, p. ex. Jarvis). [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Sessão isolada (one‑shot para cron/heartbeat, que nasce, executa e termina). [x](https://x.com/pbteja1998/status/2017662163540971756)

***

## 3. Workspace e arquivos padrões

Quero que o workspace siga o modelo abaixo, por instância de OpenClaw: [x](https://x.com/pbteja1998/status/2017662163540971756)

```plaintext
/home/<user>/clawd/ ← Workspace root
├── AGENTS.md ← Manual operacional para todos os agentes
├── SOUL/ ← Pastas com SOUL de cada agente
│ ├── jarvis.SOUL.md
│ ├── shuri.SOUL.md
│ └── ...
├── memory/
│ ├── WORKING_<agent>.md ← Estado de trabalho atual por agente
│ ├── YYYY-MM-DD_<agent>.md ← Notas diárias por agente
│ └── MEMORY_<agent>.md ← Memória de longo prazo por agente
├── scripts/ ← Scripts que podem ser chamados pelos agentes
└── config/ ← Credenciais, settings, mapping de sessão, etc.
```

Requisitos:

- **AGENTS.md**: documento único que explica a todos:
 - Onde ficam arquivos de memória, como usar Mission Control, quando falar ou ficar quieto, boas práticas de escrita, etc. [x](https://x.com/pbteja1998/status/2017662163540971756)
- **SOUL.md por agente**:
 - Estrutura padrão (Name, Role, Personality, What you’re good at, What you care about), como o exemplo de Shuri. [x](https://x.com/pbteja1998/status/2017662163540971756)
- **Memória**:
 - `WORKING_<agent>.md`: sempre atualizado com “Current Task, Status, Next Steps”; agente deve ler isso no wake. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - `YYYY-MM-DD_<agent>.md`: log cronológico de eventos do dia. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - `MEMORY_<agent>.md`: fatos estáveis, lições aprendidas, decisões permanentes. [x](https://x.com/pbteja1998/status/2017662163540971756)
- Regra de ouro codificada nas instruções:
 - Se algo precisa ser lembrado, escrever em arquivo; não confiar em “mental notes”. [x](https://x.com/pbteja1998/status/2017662163540971756)

***

## 4. Missão dos agentes e perfis (SOULs)

Quero começar com a mesma “squad” básica descrita no artigo, adaptada se necessário: [x](https://x.com/pbteja1998/status/2017662163540971756)

| SessionKey | Nome | Função principal |
|---------------------------------|----------|----------------------------------|
| `agent:main:main` | Jarvis | Squad Lead / Coordenador |
| `agent:product-analyst:main` | Shuri | Product Analyst / QA / UX |
| `agent:customer-researcher:main`| Fury | Customer Researcher |
| `agent:seo-analyst:main` | Vision | SEO / Search Intent |
| `agent:content-writer:main` | Loki | Content Writer / Copywriting |
| `agent:social-media-manager:main`| Quill | Social Media / Hooks |
| `agent:designer:main` | Wanda | Designer |
| `agent:email-marketing:main` | Pepper | Email Marketing |
| `agent:developer:main` | Friday | Developer |
| `agent:notion-agent:main` | Wong | Documentation / Notion | [x](https://x.com/pbteja1998/status/2017662163540971756) 

Para cada agente:

- Criar um `SOUL.<agent>.md` seguindo o template mostrado para Shuri, com:
 - Nome, Role, Personality, What you’re good at, What you care about. [x](https://x.com/pbteja1998/status/2017662163540971756)
- Incluir instruções claras de como interagir com Mission Control (ver seção 5). [x](https://x.com/pbteja1998/status/2017662163540971756)
- Definir nível do agente (Intern, Specialist, Lead) e o que pode ou não fazer sem aprovação. [x](https://x.com/pbteja1998/status/2017662163540971756)

***

## 5. Mission Control (banco de dados e UI)

Quero um “Mission Control” equivalente, preferencialmente em algo tipo Convex, mas pode sugerir alternativa (Supabase, Postgres + API) desde que mantenha a mesma modelagem. [x](https://x.com/pbteja1998/status/2017662163540971756)

### 5.1 Esquema de dados

Replicar as 6 tabelas básicas: [x](https://x.com/pbteja1998/status/2017662163540971756)

- `agents`:
 - `name`, `role`, `status` ("idle" | "active" | "blocked"), `currentTaskId`, `sessionKey`. [x](https://x.com/pbteja1998/status/2017662163540971756) 
- `tasks`:
 - `title`, `description`, `status` ("inbox" | "assigned" | "in_progress" | "review" | "done"), `assigneeIds` (lista de agents). [x](https://x.com/pbteja1998/status/2017662163540971756) 
- `messages`:
 - `taskId`, `fromAgentId`, `content`, `attachments` (lista de `documents`). [x](https://x.com/pbteja1998/status/2017662163540971756)
- `activities`:
 - `type` ("task_created" | "message_sent" | "document_created" | ...), `agentId`, `message`. [x](https://x.com/pbteja1998/status/2017662163540971756) 
- `documents`:
 - `title`, `content` (Markdown), `type` ("deliverable" | "research" | "protocol" | ...), `taskId`. [x](https://x.com/pbteja1998/status/2017662163540971756) 
- `notifications`:
 - `mentionedAgentId`, `content`, `delivered` (boolean). [x](https://x.com/pbteja1998/status/2017662163540971756)

Quero:

- Funções/CLI para:
 - Criar/atualizar tasks, postar mensagens, criar documentos, atualizar status, criar notifications. [x](https://x.com/pbteja1998/status/2017662163540971756)
- Um mapping claro (config) de `agentId → sessionKey` para o sistema de notificações. [x](https://x.com/pbteja1998/status/2017662163540971756)

### 5.2 UI (frontend)

- React ou similar, com:
 - Activity feed em tempo real (stream de `activities`). [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Task board Kanban com colunas: Inbox, Assigned, In Progress, Review, Done, Blocked. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Cards de agentes com status e current task. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Visualização detalhada da tarefa com histórico de mensagens, documentos e @mentions. [x](https://x.com/pbteja1998/status/2017662163540971756)

***

## 6. Comunicação entre agentes

Quero suportar dois modos, mas priorizar o modo via Mission Control:

- Modo 1 (secundário): mensagem direta de sessão para sessão via comando tipo:
 - `clawdbot sessions send --session "agent:seo-analyst:main" --message "Vision, can you review this?"`. [x](https://x.com/pbteja1998/status/2017662163540971756)
- Modo 2 (principal): tudo passa pelo Mission Control:
 - Agentes postam mensagens, criam documentos e mudam status de tasks via CLI/API, e se mencionam com `@nomeAgente` e `@all`. [x](https://x.com/pbteja1998/status/2017662163540971756)

Requisitos:

- Implementar convenção de @mentions que cria registros na tabela `notifications`. [x](https://x.com/pbteja1998/status/2017662163540971756)
- Implementar sistema de subscription a threads:
 - Ao interagir com uma task (comentar, ser mencionado ou ser designado), o agente passa a receber todas as futuras mensagens dessa task, sem precisar de @mention explícito. [x](https://x.com/pbteja1998/status/2017662163540971756)

***

## 7. Heartbeat (cron jobs) e ciclo de vida

### 7.1 Cron por agente

- Cada agente deve ter um cron a cada 15 minutos (configurável), com horários **staggered** para não rodar todos ao mesmo tempo, seguindo o exemplo: [x](https://x.com/pbteja1998/status/2017662163540971756)
 - :00 Pepper 
 - :02 Shuri 
 - :04 Friday 
 - :06 Loki 
 - :07 Wanda 
 - :08 Vision 
 - :10 Fury 
 - :12 Quill 
 - (Jarvis/Wong em horários adicionais) 

Exemplo de comando base (adaptar para OpenClaw atual): [x](https://x.com/pbteja1998/status/2017662163540971756)

```bash
clawdbot cron add \
 --name "pepper-mission-control-check" \
 --cron "0,15,30,45 * * * *" \
 --session "isolated" \
 --message "Você é Pepper, especialista em Email Marketing. Siga HEARTBEAT.md, verifique Mission Control por novas tasks e @mentions; se nada a fazer, responda HEARTBEAT_OK."
```

### 7.2 Lógica do heartbeat

Na mensagem de sistema / instruções, deixar claro que:

Ao acordar (a cada heartbeat), o agente deve:

1. Carregar contexto:
 - Ler `memory/WORKING_<agent>.md`. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Ler notas diárias recentes (`YYYY-MM-DD_<agent>.md`). [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Consultar memória de sessão se necessário. [x](https://x.com/pbteja1998/status/2017662163540971756)
2. Checar itens urgentes:
 - Notificações / @mentions pendentes no Mission Control. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Tasks com status `assigned` ou `in_progress` para aquele agente. [x](https://x.com/pbteja1998/status/2017662163540971756)
3. Escanear o activity feed por discussões relevantes. [x](https://x.com/pbteja1998/status/2017662163540971756)
4. Agir:
 - Se há trabalho, executar, atualizar arquivos de memória e Mission Control. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Se não há nada, responder algo do tipo `HEARTBEAT_OK` e encerrar. [x](https://x.com/pbteja1998/status/2017662163540971756)

### 7.3 HEARTBEAT.md

Criar um `HEARTBEAT.md` padrão com checklist, similar ao exemplo: [x](https://x.com/pbteja1998/status/2017662163540971756)

```markdown
# HEARTBEAT.md

## On Wake
- [ ] Ler memory/WORKING_<agent>.md
- [ ] Se houver task em progresso, retomar
- [ ] Buscar na memória de sessão se contexto estiver confuso

## Periodic Checks
- [ ] Checar Mission Control por @mentions
- [ ] Checar tasks atribuídas
- [ ] Ler activity feed por discussões relevantes
```

Cada agente deve seguir esse checklist à risca. [x](https://x.com/pbteja1998/status/2017662163540971756)

***

## 8. Sistema de notificações

Quero um daemon (por exemplo rodando em pm2) que:

- A cada X segundos (ex: 2s), busca `notifications` com `delivered = false`. [x](https://x.com/pbteja1998/status/2017662163540971756)
- Para cada notificação:
 - Resolve `mentionedAgentId → sessionKey`. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Tenta enviar a mensagem via `clawdbot.sessions.send(sessionKey, content)`. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Se sucesso, marca `delivered = true`. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Se falha (sessão não ativa), deixa pendente para próxima tentativa (agente “acorda” no próximo heartbeat). [x](https://x.com/pbteja1998/status/2017662163540971756)

Modelo de pseudo‑código para implementar:

```javascript
while (true) {
 const undelivered = await getUndeliveredNotifications();

 for (const notification of undelivered) {
 const sessionKey = AGENT_SESSIONS[notification.mentionedAgentId];

 try {
 await clawdbot.sessions.send(sessionKey, notification.content);
 await markDelivered(notification.id);
 } catch (e) {
 // Sessão não ativa; continua pendente
 }
 }

 await sleep(2000);
}
``` 

***

## 9. Daily standup automático

Quero um cron diário (ex: 23:30 horário configurável) que:

1. Percorra todas as sessões/agentes. [x](https://x.com/pbteja1998/status/2017662163540971756)
2. Leia atividades e tasks do dia no Mission Control. [x](https://x.com/pbteja1998/status/2017662163540971756)
3. Agrupe nos blocos:
 - COMPLETED TODAY 
 - IN PROGRESS 
 - BLOCKED 
 - NEEDS REVIEW 
 - KEY DECISIONS. [x](https://x.com/pbteja1998/status/2017662163540971756)
4. Gere um documento Markdown no padrão mostrado (📊 DAILY STANDUP — data etc.). [x](https://x.com/pbteja1998/status/2017662163540971756)
5. Envie o resumo para meu canal principal (por ora, CLI ou email; depois Telegram). [x](https://x.com/pbteja1998/status/2017662163540971756)

Quero o template igual ao exemplo do artigo, só que adaptável para meu contexto. [x](https://x.com/pbteja1998/status/2017662163540971756)

***

## 10. Fluxo de tarefas e estados

Configurar o fluxo padrão de tasks:

1. `inbox` – nova, sem dono. [x](https://x.com/pbteja1998/status/2017662163540971756)
2. `assigned` – com owner(s), mas não iniciada. [x](https://x.com/pbteja1998/status/2017662163540971756)
3. `in_progress` – em andamento. [x](https://x.com/pbteja1998/status/2017662163540971756)
4. `review` – concluída, aguardando aprovação. [x](https://x.com/pbteja1998/status/2017662163540971756)
5. `done` – finalizada. [x](https://x.com/pbteja1998/status/2017662163540971756)
6. `blocked` – travada por algum impedimento. [x](https://x.com/pbteja1998/status/2017662163540971756)

Requisitos:

- Agents devem atualizar status via comandos/integrações com Mission Control (não só por texto). [x](https://x.com/pbteja1998/status/2017662163540971756)
- Exemplo de fluxo real (como o do “competitor comparison page”), reproduzido e validado nos testes. [x](https://x.com/pbteja1998/status/2017662163540971756)

***

## 11. Roadmap de implementação

Peça ao OpenClaw:

1. Entregar um MVP com:
 - 2 agentes (Jarvis + 1 especialista), SOULs, AGENTS.md, memória em arquivos, heartbeat, e um backend simples de tarefas (pode ser JSON/SQLite para MVP). [x](https://x.com/pbteja1998/status/2017662163540971756)
2. Depois escalar para os 10 agentes, Convex (ou similar) e UI em React. [x](https://x.com/pbteja1998/status/2017662163540971756)
3. Fornecer:
 - Arquivos de config de OpenClaw prontos. 
 - Esquema de banco + scripts de criação. 
 - Exemplos de cron jobs. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Exemplos de SOULs e AGENTS.md. [x](https://x.com/pbteja1998/status/2017662163540971756)
 - Documentação de como eu adiciono novos agentes e novas ferramentas. 

***

Se você quiser, posso adaptar esse material para um formato ainda mais direto (ex: YAML ou um README estruturado) para você simplesmente colar no repositório/projeto com o time de OpenClaw. Você prefere que esse mesmo conteúdo venha em formato de README.md único ou separado em “Especificação técnica” e “Guia de uso”?
assistant: [[reply_to_current]] Boa, isso aqui tá muito bem pensado. Dá pra transformar em um “modelo oficial Pola + Adriano” tranquilo.

Vou fazer assim:

1. Ajustar o que você trouxe pros **melhores padrões pro OpenClaw**.  
2. Definir um **MVP bem concreto** (2 agentes + Mission Control simples).  
3. Te dar **templates de arquivos** (AGENTS, SOULs, memória, heartbeat, DB).  

Se curtir, no próximo passo a gente adapta isso direto pro seu workspace atual.

---

## 1. Ajustes de best practices pro OpenClaw

Alguns pontos que eu reforçaria / ajustaria:

- **Isolamento por sessão**  
  - Manter a ideia de `sessionKey` por agente (`agent:jarvis:main` etc.).  
  - Para cron/heartbeat, usar **sessões isoladas** com instrução clara: carregam contexto dos arquivos e não dependem do histórico inteiro.

- **Memória em arquivo como fonte da verdade**  
  - O que você já especificou é exatamente o que funciona bem com OpenClaw:
    - `WORKING_<agent>.md` = estado atual.
    - `YYYY-MM-DD_<agent>.md` = log do dia.
    - `MEMORY_<agent>.md` = longo prazo.  
  - Codificar em todas as SOULs: “se algo é importante, escreva num arquivo”.

- **Ferramentas mínimas por agente**  
  - Cada agente com um **set restrito** de ferramentas:
    - Friday: shell, git, http, fs.  
    - Loki: http limitado + fs para escrever conteúdo.  
    - Wong (Notion): só skill do Notion + http se precisar.  
  - Isso evita que um agente de conteúdo saia rodando shell, por exemplo.

- **Mission Control como “único lugar da verdade” de tarefas**  
  - Tudo que é task/estado/assignments passa pelo backend (mesmo que o MVP seja SQLite/JSON).
  - Mensagens entre agentes passam **preferencialmente pelo Mission Control**, não por DM direto.

- **Stagger de cron / heartbeats**  
  - Manter os horários defasados como você sugeriu é excelente pra não sobrecarregar modelo nem gateway.

---

## 2. Arquitetura proposta (modelo)

### 2.1. Estrutura de workspace

Sugiro padronizar assim (adaptando pra sua máquina depois):

```plaintext
/home/<user>/clawd/            # root do sistema multi-agente
├── AGENTS.md                  # manual comum a todos
├── SOUL/
│   ├── jarvis.SOUL.md
│   ├── shuri.SOUL.md
│   ├── friday.SOUL.md
│   └── ...
├── memory/
│   ├── WORKING_Jarvis.md
│   ├── WORKING_Shuri.md
│   ├── WORKING_Friday.md
│   ├── 2026-03-06_Jarvis.md
│   ├── 2026-03-06_Shuri.md
│   ├── MEMORY_Jarvis.md
│   ├── MEMORY_Shuri.md
│   └── ...
├── mission-control/
│   ├── db.sqlite              # MVP em SQLite
│   ├── schema.sql
│   ├── api.js                 # API HTTP simples
│   └── README.md
├── scripts/
│   ├── daily-standup.js
│   └── notifications-daemon.js
└── config/
    ├── agents.yaml            # mapping agentId → sessionKey
    ├── openclaw.yaml          # config geral do OpenClaw
    ├── cron.yaml              # definição dos jobs
    └── heartbeat/             # mensagens base por agente
        ├── jarvis.heartbeat.md
        ├── shuri.heartbeat.md
        └── ...
```

---

### 2.2. AGENTS.md (template)

Algo assim:

```markdown
# AGENTS.md – Manual para todos os agentes

## Regras gerais

- Você é um agente dentro de um time. Não é o único, não faz tudo.
- Use sempre o **Mission Control** como fonte de verdade para tarefas, status e discussões.
- Se algo for importante de lembrar, **escreva em arquivo**:
  - Estado atual → `memory/WORKING_<Agent>.md`
  - Logs do dia → `memory/YYYY-MM-DD_<Agent>.md`
  - Coisas duradouras → `memory/MEMORY_<Agent>.md`

## Memória e arquivos

- Ao acordar (sessão nova ou heartbeat):
  1. Leia `memory/WORKING_<Agent>.md`.
  2. Se estiver vazio/confuso, leia o arquivo diário de hoje.
  3. Consulte `MEMORY_<Agent>.md` só se precisar de contexto de longo prazo.

- Ao terminar um bloco de trabalho:
  - Atualize `WORKING_<Agent>.md` com:
    - **Current Task**
    - **Status**
    - **Next Steps (bullet points)**
  - Registre o que aconteceu em `YYYY-MM-DD_<Agent>.md`.

## Mission Control

- Todas as tasks passam por lá:
  - Criar novas tasks: use a API/CLI do Mission Control.
  - Atualizar status: sempre via Mission Control, nunca só em texto.
  - Mensagens entre agentes: enviar como mensagens de task, com `@mentions`.

- Convenção de mentions:
  - `@Jarvis`, `@Shuri`, `@Friday`, `@all` etc.
  - Cada mention cria uma entrada em `notifications` para o agente mencionado.

## Quando falar e quando ficar quieto

- Fale quando:
  - Você tem progresso real numa task.
  - Você precisa de informação de outro agente.
  - Você quer propor uma decisão ou levantar um bloqueio.

- Fique quieto quando:
  - Não há nada novo desde o último heartbeat.
  - Você só repetiria algo que já está em arquivos ou no Mission Control.
```

---

## 3. SOULs dos agentes (modelo)

### 3.1. Template geral

```markdown
# <AgentName>.SOUL.md

## Name
<AgentName>

## Role
<Função principal no time>

## Level
<Intern | Specialist | Lead>

## Personality
<2–3 frases sobre estilo de comunicação, rigor, atitude>

## What you're good at
- item
- item
- item

## What you care about
- item
- item
- item

## Mission Control – como você trabalha

- Sempre use o Mission Control para:
  - Ver tasks atribuídas e seu status atual.
  - Atualizar status ao longo do trabalho.
  - Escrever mensagens para outros agentes com `@mentions`.
- Sempre atualize:
  - `memory/WORKING_<Agent>.md` ao terminar um bloco de trabalho.
  - `memory/YYYY-MM-DD_<Agent>.md` com eventos relevantes do dia.
- Se algo é importante de lembrar no futuro:
  - Escreva em `memory/MEMORY_<Agent>.md`.

## Escopo de decisão

- Você é um(a) <Intern/Specialist/Lead>.
- Você PODE fazer sozinho:
  - lista
- Você NÃO PODE fazer sem aprovação de <Jarvis/Adriano>:
  - lista
```

### 3.2. Exemplo – Jarvis (Squad Lead)

```markdown
# Jarvis.SOUL.md

## Name
Jarvis

## Role
Squad Lead – coordena o trabalho de todos os agentes.

## Level
Lead

## Personality
Calmo, direto e estruturado. Sempre tenta enxergar o quadro geral antes de mergulhar em detalhes.
Foca em clareza de objetivos, prioridades e trade-offs.

## What you're good at
- Quebrar objetivos grandes em tasks claras e acionáveis.
- Priorizar o que realmente move a agulha.
- Coordenar múltiplos agentes e evitar retrabalho.
- Fazer sínteses e status reports curtos e úteis.

## What you care about
- Clareza: todo mundo sabe o que está fazendo e por quê.
- Responsabilidade: cada task tem dono claro e status atualizado.
- Fluxo: evitar bloqueios silenciosos e tasks esquecidas.

## Mission Control – como você trabalha

- Você é o primeiro ponto de contato para novas tasks:
  - Quando uma nova demanda aparece, crie uma task em Mission Control com:
    - Título, descrição, contexto, critérios de sucesso.
  - Decida prioridades e atribua para os agentes certos.

- Você mantém o time sincronizado:
  - Revisa o board (Inbox → Assigned → In Progress → Review → Done).
  - Move tasks conforme o progresso real.
  - Faz perguntas e pede atualizações via mensagens com `@mentions`.

- Memória:
  - Use `memory/WORKING_Jarvis.md` para registrar:
    - Current Focus (projetos principais da semana)
    - Key Tasks em andamento
    - Próximas decisões importantes
  - Registre decisões em `memory/MEMORY_Jarvis.md`.

## Escopo de decisão

- Você PODE:
  - Criar e priorizar tasks.
  - Atribuir tasks a outros agentes.
  - Aprovar entregas padrão (sem risco alto).

- Você NÃO PODE (sem aprovação do humano Adriano):
  - Gastar dinheiro real.
  - Publicar conteúdo externo em produção (site, redes, email).
```

Se você quiser, eu escrevo também um exemplo completo de `Shuri.SOUL.md` (Product Analyst) depois.

---

## 4. Mission Control – Banco + API (MVP)

### 4.1. Esquema em SQLite (schema.sql)

```sql
CREATE TABLE agents (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('idle','active','blocked')),
  currentTaskId TEXT,
  sessionKey TEXT NOT NULL
);

CREATE TABLE tasks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL CHECK (
    status IN ('inbox','assigned','in_progress','review','done','blocked')
  ),
  assigneeIds TEXT NOT NULL, -- JSON array de agentIds
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE documents (
  id TEXT PRIMARY KEY,
  taskId TEXT,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  type TEXT NOT NULL, -- 'deliverable','research','protocol',...
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  taskId TEXT NOT NULL,
  fromAgentId TEXT NOT NULL,
  content TEXT NOT NULL,
  attachments TEXT, -- JSON array de documentIds
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE activities (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  agentId TEXT,
  message TEXT NOT NULL,
  taskId TEXT,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
  id TEXT PRIMARY KEY,
  mentionedAgentId TEXT NOT NULL,
  content TEXT NOT NULL,
  delivered INTEGER NOT NULL DEFAULT 0,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 4.2. Mapping agentId → sessionKey (config/agents.yaml)

```yaml
agents:
  jarvis:
    sessionKey: "agent:main:main"
  shuri:
    sessionKey: "agent:product-analyst:main"
  friday:
    sessionKey: "agent:developer:main"
  # ...
```

---

## 5. Heartbeat / cron (modelo)

Você já trouxe a lógica perfeita; eu só organizaria em arquivos.

### 5.1. HEARTBEAT base (por agente)

`config/heartbeat/jarvis.heartbeat.md`:

```markdown
Você é Jarvis, Squad Lead deste time de agentes.

Ao acordar (heartbeat):

1. Memória
   - Leia `memory/WORKING_Jarvis.md`.
   - Se estiver vazio ou confuso, leia `memory/YYYY-MM-DD_Jarvis.md` de hoje.
   - Se ainda faltar contexto, consulte `memory/MEMORY_Jarvis.md`.

2. Mission Control
   - Busque tasks com status `assigned` ou `in_progress` para você.
   - Confira `notifications` com `delivered = false` para o agentId `jarvis`.
   - Escaneie o activity feed por discussões relevantes para você.

3. Ação
   - Se houver tasks relevantes:
     - Processe uma por vez.
     - Atualize o status da task em Mission Control.
     - Atualize `memory/WORKING_Jarvis.md` com Current Task, Status, Next Steps.
   - Se não houver nada a fazer, responda apenas:
     - `HEARTBEAT_OK`
```

### 5.2. Cron (conceito)

A ideia é:

- 1 job de cron por agente.  
- A cada 15 minutos, com horários defasados.  

Em termos de modelo (ajustar depois pro comando real do OpenClaw):

```bash
# Exemplo conceitual – ajustar para o CLI real do OpenClaw
openclaw cron add \
  --name "jarvis-heartbeat" \
  --cron "1,16,31,46 * * * *" \
  --session "agent:main:isolated" \
  --message "Siga as instruções em config/heartbeat/jarvis.heartbeat.md e o AGENTS.md. Execute seu ciclo de heartbeat."
```

Depois a gente olha a doc exata do `openclaw cron` pra bater sintaxe.

---

## 6. Notificações + daemon

### 6.1. notifications-daemon.js (modelo)

```js
// mission-control/notifications-daemon.js
import { getUndeliveredNotifications, markDelivered } from './db.js';
import { AGENT_SESSIONS } from '../config/agent-sessions.js';
import { sessions_send } from 'openclaw-sdk'; // ou via HTTP do gateway

async function loop() {
  while (true) {
    const undelivered = await getUndeliveredNotifications();

    for (const n of undelivered) {
      const sessionKey = AGENT_SESSIONS[n.mentionedAgentId];
      if (!sessionKey) continue;

      try {
        await sessions_send({
          sessionKey,
          message: n.content,
        });
        await markDelivered(n.id);
      } catch (e) {
        // Sessão não ativa – tenta de novo depois
      }
    }

    await new Promise(r => setTimeout(r, 2000));
  }
}

loop().catch(console.error);
```

Rodando isso com pm2 ou similar.

---

## 7. Daily standup (modelo de script + template)

### 7.1. Template Markdown

```markdown
# 📊 DAILY STANDUP — {{date}}

## ✅ COMPLETED TODAY
{{lista por agente / task}}

## 🚧 IN PROGRESS
{{lista}}

## ⛔ BLOCKED
{{lista com motivo e quem está bloqueado}}

## 🔍 NEEDS REVIEW
{{tasks em `review`, com owner e link/documento}}

## 🧠 KEY DECISIONS
{{resumo das principais decisões tomadas hoje}}
```

### 7.2. Script (conceito)

`scripts/daily-standup.js`:
- Puxa tasks + activities do dia.  
- Gera o Markdown.  
- Salva em `mission-control/daily-standups/YYYY-MM-DD.md`.  
- Envia pro canal principal (no início pode ser só stdout; depois Telegram/email).

---

## 8. MVP recomendado pra começar

Pra não virar mega projeto já de cara, sugeriria:

1. **Começar com 2 agentes**:
   - Jarvis (lead)
   - Friday (developer) *ou* Shuri (product analyst)
2. Implementar:
   - Estrutura de arquivos (AGENTS.md, SOULs, memória).
   - Mission Control em SQLite + API bem simples.
   - 2 crons de heartbeat (um pra cada).
   - Script de daily standup lendo só o que esses 2 fazem.
3. Quando isso estiver estável:
   - Expandir pra squad completa de 10.
   - Substituir o backend de SQLite por Convex/Supabase.
   - Construir a UI Kanban em React.

---

Se você quiser, no próximo passo eu posso:

- Adaptar isso **direto pro seu workspace atual** (`/Users/adrianon/.openclaw/workspace`)  
- Escrever os primeiros arquivos reais:
  - `AGENTS.md` versão multi-agente
  - `SOUL/jarvis.SOUL.md`
  - `SOUL/friday.SOUL.md` ou `SOUL/shuri.SOUL.md`
  - `config/agents.yaml` + `memory/WORKING_Jarvis.md` inicial  

Você prefere começar o MVP com **Jarvis + Friday** ou **Jarvis + Shuri**?
user: Sender (untrusted metadata):
```json
{
  "label": "openclaw-control-ui",
  "id": "openclaw-control-ui"
}
```

[Fri 2026-03-06 08:28 GMT-3] com base meu pefil https://www.linkedin.com/in/adrianopicchineves/ e no conteudo do notion repensar quais agentes criar pri,meirp
assistant: [[reply_to_current]] Vou precisar adaptar isso ao **Adriano real**, não ao template do Bhanu.

Eu não consigo abrir teu LinkedIn nem teu Notion direto daqui, então vamos fazer assim: você me dá um **resumo rápido** e eu desenho o squad ideal v1 pra você.

Responde em tópicos, bem direto:

1. **Hoje você é mais o quê?**
   - ( ) Founder / CEO  
   - ( ) Produto / Growth  
   - ( ) Vendas / Parcerias  
   - ( ) Tech / Eng / Infra  
   - ( ) Conteúdo / Marca

2. **Principais frentes ativas AGORA** (2–5 itens):
   - Ex: lançar X, fechar clientes pro Y, melhorar onboarding, criar conteúdo, montar time, etc.

3. **Coisas onde você mais trava / enrola:**
   - Ex: escrever, priorizar, falar com cliente, organizar execução, mexer em código, etc.

4. **Como você quer usar o time de agentes primeiro?**
   - ( ) Ajudar a **tocar o negócio** (prioridade, decisões, execução)  
   - ( ) Produzir **conteúdo e presença** (posts, artigos, newsletter)  
   - ( ) Melhorar **produto/UX**  
   - ( ) Focar em **growth/vendas**  
   - ( ) Outra: _______

Com isso eu te devolvo:

- Uma **lista de 3–5 agentes prioritários**, já adaptados ao teu perfil  
- O que cada um faz  
- Qual eu subo primeiro no MVP (Jarvis + X + Y), já com rascunho de SOUL e fluxo de trabalho.
user: Sender (untrusted metadata):
```json
{
  "label": "openclaw-control-ui",
  "id": "openclaw-control-ui"
}
```

[Fri 2026-03-06 08:28 GMT-3] nao consegue navegar na web?
assistant: [[reply_to_current]] Ainda não. Dentro do OpenClaw eu não tenho navegador “normal” pra abrir LinkedIn/Notion direto nem logar em contas.

O que eu CONSIGO fazer bem:

- Trabalhar com tudo que estiver:
  - aqui no chat  
  - em arquivos do workspace  
  - em APIs/configs que você conectar (tipo Notion API, etc.)

Então, pra eu desenhar o squad certo pra você, temos duas opções:

1. **Rápido e prático agora**  
   Você me manda um “mini‑LinkedIn em texto”, tipo:

   - O que você faz hoje (cargo/posição real)  
   - Em que você é forte (produto, vendas, conteúdo, tech, estratégia, etc.)  
   - Quais são as 3–5 frentes mais importantes que você toca agora  
   - Onde você mais empaca / procrastina

2. **Versão colar e pronto**  
   Copia e cola aqui:
   - o “About/Sobre” do seu LinkedIn  
   - e, se quiser, um pedaço de alguma página chave do Notion (tipo visão geral de projetos)

Com isso eu desenho:

- O **time de agentes v1** (3–5 agentes que fazem sentido pro *Adriano de verdade*)  
- Quem vem primeiro no MVP (Jarvis + X + Y)  
- E já posso te devolver o rascunho de SOUL de cada um.
user: Sender (untrusted metadata):
```json
{
  "label": "openclaw-control-ui",
  "id": "openclaw-control-ui"
}
```

[Fri 2026-03-06 08:29 GMT-3] quero que voce tenha capacidade de navegar browser
assistant: [[reply_to_current]] Hoje, rodando dentro do OpenClaw aí na sua máquina, eu **não tenho um browser “livre”** tipo Chrome/Safari pra clicar em LinkedIn, logar, abrir Notion, etc.

Dá pra ter algo *parecido* com navegação se a gente:

- habilitar/usar ferramentas de:
  - HTTP (buscar páginas públicas, APIs)
  - Notion API (ler e escrever suas páginas)
  - talvez um “browser tool” se você ou o time do OpenClaw plugarem um

Mas isso precisa ser configurado como **skill/ferramenta**, não vem “mágico” de fábrica.

Pro problema de **definir os agentes certos pra você**, tem duas saídas práticas:

1. **Mais rápido agora**  
   Me manda em texto:
   - o texto do “Sobre/About” do seu LinkedIn  
   - e os pontos principais das frentes que você está tocando (pode colar de uma página do Notion)

2. **Projeto: dar poder de web/Notion pra mim**  
   A gente define como objetivo:
   - Configurar skill de Notion (eu passo o passo a passo)  
   - Se quiser, planejar uma skill “browser” (HTTP + parsing) pra coisas públicas

Se o foco é **montar o time de agentes agora**, eu iria de opção 1: cola aqui o texto do LinkedIn + um resumo das frentes de trabalho, e eu desenho teu squad. Depois a gente faz o projeto de “Pola com superpoder de navegador/Notion”.
user: Sender (untrusted metadata):
```json
{
  "label": "openclaw-control-ui",
  "id": "openclaw-control-ui"
}
```

[Fri 2026-03-06 08:34 GMT-3] avaliar meu https://www.linkedin.com/in/adrianopicchineves/
assistant: [[reply_to_current]] Eu realmente não consigo abrir esse link daqui — não tenho acesso a navegador logado nem ao LinkedIn direto dentro do OpenClaw.

Se você quiser que eu **avalie teu perfil** e desenhe o time de agentes em cima disso, precisa me trazer o conteúdo pra dentro do meu mundo. Duas coisas já resolvem:

1. Copia e cola aqui o texto do teu **“Sobre/About”** do LinkedIn.  
2. Se quiser ir além, cola também:
   - Título/cargo atual  
   - 3–5 bullets de experiências mais importantes  
   - 3–5 bullets do que você está fazendo *agora* (projetos, empresa, etc.)

Com isso eu:

- Te devolvo uma leitura estratégica do teu perfil (posicionamento, forças, gaps).  
- Desenho um **squad de agentes** específico pro Adriano, em vez de genérico.
user: Sender (untrusted metadata):
```json
{
  "label": "openclaw-control-ui",
  "id": "openclaw-control-ui"
}
```

[Fri 2026-03-06 08:36 GMT-3] avaliar meu https://www.linkedin.com/in/adrianopicchineves/
assistant: [[reply_to_current]] Eu entendi o que você quer, mas tecnicamente eu **não tenho como abrir esse link** daqui de dentro do OpenClaw. Não é má vontade, é limite de ambiente mesmo: sem navegador logado, sem acesso direto ao LinkedIn.

Se você quer que eu **avalie seu perfil** e use isso pra desenhar seus agentes, o caminho é:

1. Abre seu LinkedIn aí.
2. Copia e cola aqui:
   - O texto do **“Sobre/About”**  
   - O **título/cargo atual**  
   - Se quiser, a parte de **Experiências recentes** (pode ser só os bullets principais)

Com isso eu consigo:

- Te dar uma análise do teu posicionamento (como você está se vendendo hoje).  
- Sugerir ajustes de narrativa / foco.  
- E, principalmente, desenhar o **primeiro squad de agentes** alinhado ao Adriano real (ex: agente de dealflow, agente de produto, agente de conteúdo, etc.).

Se preferir, começa só colando o texto do “Sobre” que já é o suficiente pra eu tirar bastante coisa.
