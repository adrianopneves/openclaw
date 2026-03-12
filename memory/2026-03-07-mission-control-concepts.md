# Mission Control / Multi-Agent Concepts (v2)

Atualização dos conceitos para criação de novos agentes e de um "Mission Control" baseado em OpenClaw, pensando em boas práticas atuais e no teu contexto (Notion + PARA + multi-agente).

---

## 1. Sessões como agentes (mas com camadas)

- Cada **agente operacional** = 1 sessão OpenClaw com:
  - `sessionKey` próprio
  - `SOUL.md` e `IDENTITY.md` específicos
  - conjunto de ferramentas/skills definido (Notion, Gmail, web, etc.)
  - memória em arquivos (no mesmo workspace)
- Além disso, faz sentido ter **camadas de agente**:
  - **Squad Lead / Orquestrador** (ex.: Pola): recebe demandas do humano, prioriza, delega.
  - **Especialistas**: Notion/Docs, Pesquisa, Conteúdo, Dev, etc.
  - **Infra/roteador** (opcional, mais avançado): um agente que decide a qual especialista mandar cada tarefa.

---

## 2. Mission Control (cérebro compartilhado)

- Usar um sistema único de tarefas (idealmente **Notion**) como "Mission Control":
  - Todos os agentes leem/escrevem nesse mesmo lugar.
  - Uma database de **Tasks** com campos como:
    - `Title`
    - `Status`: Inbox → Assigned → In progress → Review → Done → Blocked
    - `Owner (Human/Agent)`: Adriano, Pola, Notion Agent, etc.
    - `Agent Session Key` (quando for tarefa de agente)
    - `Project` (link para Projects PARA)
    - `Priority` (Now / Next / Later)
  - Comentários, decisões e links para entregáveis ficam presos à task, não à conversa solta.
- Documentos de saída (pesquisas, drafts, specs) idealmente em:
  - Notion (páginas vinculadas à task), ou
  - arquivos markdown no workspace, mas sempre linkados na task.

---

## 3. Papéis e personalidades (SOUL)

- Cada agente deve ter um **escopo bem estreito** e uma personalidade funcional:
  - Ex.: "Notion/Docs", "Pesquisa de Mercado", "Conteúdo Longo", "SEO", "Dev/Automação".
- `SOUL.md` de cada agente define:
  - Quem é (nome, papel, nível de autonomia).
  - O que faz bem (skills principais).
  - O que prioriza (velocidade vs. qualidade, evidência vs. intuição, etc.).
  - Como se comunica (curto e direto, explicativo, etc.).
- `AGENTS.md` central define:
  - Regras compartilhadas: como usar memória, como referenciar Notion, como registrar decisões.
  - Quando falar com o humano e quando só atualizar arquivos/Notion.

---

## 4. Modelo de memória (prático)

- **Sessão**: bom para contexto imediato, mas não confiável como memória de médio/longo prazo.
- **Arquivos no workspace** são a memória real:
  - `memory/WORKING.md` ou `memory/<agent>-working.md`:
    - Task atual
    - Status
    - Próximos passos
  - `memory/YYYY-MM-DD.md`:
    - Log diário de eventos relevantes (por agente ou geral).
  - `MEMORY.md`:
    - Decisões estáveis, fatos permanentes, convenções (ex.: estrutura do PARA, naming conventions, prioridades de vida/trabalho).
- Regra de ouro (mantida): se algo precisa ser lembrado **para além dessa sessão**, registrar em arquivo.

---

## 5. Heartbeats / cron (com estratégia de custo)

- Heartbeat serve para:
  - Acordar agentes periodicamente.
  - Checar Mission Control (Notion), @mentions, WORKING.md.
  - Fazer avanços incrementais ou reportar "nada a fazer".
- Boas práticas:
  - Frequência padrão entre **15–30 min** para agentes ativos.
  - Usar **modelos mais baratos** para heartbeats e monitoração; deixar modelos mais caros para criação/crítica de conteúdo.
  - Stagger (escalonar) horários de acordar para não concentrar custo.
- `HEARTBEAT.md` define checklist objetiva por agente ou global:
  - O que checar na ordem (memory, Notion tasks, notificações, etc.).
  - Em que condições avisar o Adriano vs. só atualizar estado.

---

## 6. Notificações, @mentions e colaboração

- Mesmo usando Notion como Mission Control, manter o conceito:
  - @mentions ou campos do tipo "Assigned to" indicam quem precisa agir.
  - Um agente que mexeu numa task fica **inscrito** naquele tópico (segue acompanhando).
- Quando viável, implementar camada de notificações:
  - Agente de infra ou cron que escaneia Notion em busca de tasks/updates relevantes.
  - Usa `sessions_send` para pingar o agente correto.
- Importante: reduzir ruído para o humano.
  - Só levar para você aquilo que: 
    - exige decisão, ou
    - está bloqueado, ou
    - é entrega pronta para revisão.

---

## 7. Standups / relatórios para o Adriano

- Manter o conceito de **daily standup**, mas adaptado ao teu uso:
  - Pode ser 1x/dia ou 1x a cada 2–3 dias.
  - Estrutura sugerida:
    - ✅ Concluído desde o último relatório
    - 🔄 Em progresso
    - 🚫 Bloqueado (e por quê)
    - 👀 Precisa de revisão/decisão do Adriano
- Esses relatórios podem ser:
  - Gerados por um agente "Squad Lead" (Pola) lendo Mission Control + memória.
  - Entregues no canal principal (webchat/Telegram).

---

## 8. Filosofia de design (refinada)

- Tratar agentes como **membros de equipe**, não como "chatbots genéricos":
  - Dar responsabilidades claras e métricas de sucesso (ex.: "manter Projects PARA limpo", "resumir email importante", etc.).
  - Definir **níveis de autonomia** (Intern, Specialist, Lead) conforme confiança.
- Começar pequeno e concreto:
  - 1) Um Squad Lead (Pola) + 1 especialista (Notion/Docs) já conectados ao teu PARA.
  - 2) Adicionar especialista de Email/Gmail assim que integração estiver madura.
  - 3) Depois, Conteúdo/SEO/Research se fizer sentido.
- Sempre acoplar novos agentes a:
  - Um lugar claro de input (Tasks no Notion, emails, calendário).
  - Um lugar claro de output (Notion pages, arquivos, ou mensagens para você).

Usar esta versão (v2) como base sempre que formos desenhar novos agentes ou ajustar o ecossistema multi-agente do Adriano, especialmente em torno de Notion + PARA + email + Mission Control.