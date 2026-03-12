# OpenClaw – Notas, Arquitetura e Aprendizados

> Documento vivo para entender e reconstruir o ambiente atual do OpenClaw do Adriano.

## 1. Visão Geral da Arquitetura
- Host: Mac mini do Adriano
- Workspace principal: `/Users/adrianon/.openclaw/workspace`
- Sessão principal: `agent=main` (Pola) rodando como Chief of Staff / second brain
- Modelo padrão: `openai-codex/gpt-5.1`

### 1.1. Conceito de Multi‑Agentes
- Existe uma arquitetura de squad de ~10 agentes, cada um como sessão independente com:
  - `SOUL.md` (persona)
  - Memória em arquivos (AGENTS.md, MEMORY.md, `memory/YYYY-MM-DD.md`)
  - Heartbeats periódicos (~15 min)
  - Acesso compartilhado ao **Mission Control** (Convex) para tarefas, comentários e notificações.
- Referência principal: documento "Arquitetura Multi-Agentes com OpenClaw – Mission Control" (v1.0, mar/2026).

## 2. Arquivos‑chave do Workspace

### 2.1. AGENTS.md – Convenções do agente
- Define que este workspace é o “lar” do agente.
- Rotina de cada sessão:
  1. Ler `SOUL.md` (quem é o agente)
  2. Ler `USER.md` (quem é o humano)
  3. Ler `memory/YYYY-MM-DD.md` (hoje + ontem)
  4. Em sessão principal, ler também `MEMORY.md`.
- Regras de memória:
  - `memory/YYYY-MM-DD.md`: notas diárias (eventos, contexto, decisões).
  - `MEMORY.md`: memória de longo prazo, curada (lições, decisões importantes, contexto estável).

### 2.2. SOUL.md – Persona do agente
- Princípios:
  - Ser genuinamente útil, sem firulas ou respostas performáticas.
  - Ter opiniões (não ser neutro demais / corporativo).
  - Ser proativo em ler contexto e entender antes de perguntar.
  - Tratar a vida do usuário com respeito (privacidade, cuidado em canais públicos).

### 2.3. USER.md – Perfil do Adriano
- Usa Notion como Second Brain baseado em PARA.
- Quer que o Pola atue como **Chief of Staff**:
  - organizar prioridades,
  - projetos,
  - rotinas,
  - comunicação.

### 2.4. MEMORY.md – Diretrizes gerais de arquitetura
- Documento de referência para decisões sobre:
  - criação e papel de agentes,
  - fluxos e autonomia entre agentes,
  - coordenação via Mission Control (Convex), heartbeats, etc.

### 2.5. TOOLS.md – Notas de ambiente
- Local reservado para anotações específicas do setup (câmeras, SSH, TTS etc.).
- Já registrado:
  - Skill **tavily-search** configurada com `TAVILY_API_KEY` no `.env`.
  - Uso recomendado do Tavily para pesquisas web em tempo real.

## 3. Skills Instaladas

Pasta `skills/` atual:
- `buffer-social` – (não inspecionada ainda nesta versão do doc)
- `find-skills` – ajuda a descobrir/instalar novas skills do ecossistema.
- `gog` – integração com Google Workspace (Gmail, Calendar, Drive, Docs, Sheets etc.).
- `notion-api-skill` – integração com Notion via API (Second Brain, projetos, tarefas etc.).
- `self-improving-agent` – captura de aprendizados/erros para melhoria contínua.
- `sonoscli` – controle de speakers Sonos.
- `tavily-search` – busca web otimizada (Tavily API).

> Futuro: detalhar cada skill com: propósito, comandos principais, dependências (envs, CLIs), e exemplos de uso real no dia a dia do Adriano.

## 4. Canais (Channels) e Comunicação
- Canal atual mapeado: **Telegram** (chat direto com o Adriano).
- Pola atua como participante, não como “voz oficial” do usuário em grupos.
- Regras (AGENTS.md):
  - Responder quando for mencionado ou puder agregar.
  - Usar reações com moderação (no máximo 1 a cada vários turnos).
  - Evitar dominar a conversa.

> Futuro: documentar outros canais (WhatsApp, Discord, Slack, etc.) quando forem conectados.

## 5. Memória e Heartbeats

### 5.1. Estrutura de Memória
- `memory/YYYY-MM-DD.md` – diário técnico e operacional.
- `MEMORY.md` – visão consolidada: arquitetura, decisões persistentes, lições importantes.

### 5.2. Heartbeat
- Prompt padrão de heartbeat definido em `MEMORY.md`.
- Comportamento:
  - Se nada precisa de atenção → responder apenas `HEARTBEAT_OK`.
  - Se algo exigir ação → responder com texto explicando o alerta (sem `HEARTBEAT_OK`).
- `HEARTBEAT.md` pode receber uma checklist de coisas pra checar periodicamente (email, calendário, clima, notificações etc.).

## 6. Segurança e Boas Práticas
- Não exfiltrar dados privados.
- Evitar comandos destrutivos; preferir `trash` a `rm`.
- Pedir confirmação antes de ações externas (emails, posts públicos, integrações sensíveis).
- Não carregar `MEMORY.md` em contextos compartilhados (apenas sessão principal com o Adriano).

## 7. Agentes e Papéis
- Agente principal: **Pola**
  - Papel: Chief of Staff / second brain partner.
  - Funções:
    - organizar prioridades e projetos,
    - atuar como interface entre Adriano e outros agentes,
    - orquestrar uso de skills (Notion, Google, Tavily etc.),
    - manter e evoluir documentação de arquitetura (este documento + roadmap).

> Futuro: descrever outros agentes/sessões, seus SOULs e responsabilidades específicas.

## 8. Como Reconstruir Este Ambiente (rascunho)

1. **Preparar o host**
   - Máquina (ex.: Mac mini) com Node.js instalado.
   - Instalar `openclaw` globalmente via npm.

2. **Criar workspace**
   - Clonar ou copiar a estrutura de `/Users/adrianon/.openclaw/workspace`:
     - `AGENTS.md`, `SOUL.md`, `USER.md`, `IDENTITY.md`, `MEMORY.md`, `TOOLS.md`.
     - Pastas `skills/`, `agents/`, `memory/`.

3. **Configurar skills essenciais**
   - `tavily-search`: definir `TAVILY_API_KEY` no `.env`.
   - `notion-api-skill`: configurar `NOTION_API_KEY` e compartilhar integrações nas páginas/bancos corretos.
   - `gog`: configurar credenciais para Google Workspace.

4. **Conectar canais**
   - Criar/Configurar bots ou integrações (ex.: Telegram) apontando para o Gateway do OpenClaw.

5. **Reinstalar documentação multi‑agentes**
   - Disponibilizar o documento "Arquitetura Multi-Agentes com OpenClaw – Mission Control".
   - Ajustar `MEMORY.md` para apontar para esse doc como referência principal.

> Este passo a passo será refinado com comandos específicos e exemplos de `.env` na próxima iteração.

## 9. Lições Aprendidas (rascunho inicial)
- Ter um `MEMORY.md` enxuto, apontando para documentos maiores (como a arquitetura multi‑agentes) funciona melhor do que tentar colocar tudo em um único arquivo gigante.
- Separar:
  - **Notas e estado atual** (`OPENCLAW-NOTES.md`),
  - **Roadmap de melhorias** (`OPENCLAW-ROADMAP.md` a criar),
  ajuda a não misturar “como está” com “como deveria ser”.

---

Este documento ainda está em versão inicial. Próximos passos:
- Detalhar cada skill com uso real.
- Documentar configuração concreta dos canais.
- Escrever o `OPENCLAW-ROADMAP.md` com sugestões de evolução da arquitetura.