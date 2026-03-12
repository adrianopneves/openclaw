# OpenClaw – Roadmap de Evolução

> Documento para registrar ideias de melhoria, próximos passos e experimentos no ambiente OpenClaw do Adriano.

## 1. Objetivos Gerais
- Deixar o Pola cada vez mais útil como **Chief of Staff**.
- Aumentar a autonomia dos agentes sem perder controle e segurança.
- Ter um ambiente fácil de **reconstruir** e **evoluir** (documentação + infra simples).

## 2. Melhorias na Arquitetura
- [ ] Detalhar e criar os demais agentes do squad (~10) com SOUL próprio e papéis claros.
- [ ] Formalizar o uso do **Mission Control (Convex)** como fonte única de:
  - tarefas,
  - comentários,
  - notificações entre agentes.
- [ ] Definir níveis de autonomia para cada agente (o que podem decidir/rodar sozinhos).

## 3. Skills e Integrações
- [ ] Notion
  - [ ] Configurar e testar a skill `notion-api-skill` para acessar o Second Brain (projetos, tarefas, notas).
  - [ ] Mapear databases principais (Projetos, Tarefas, Áreas, Recursos) no modelo PARA.
  - [ ] Criar fluxos padrão: "Pola, lista projetos ativos", "Pola, o que tenho para hoje", etc.

- [ ] Google Workspace (gog)
  - [ ] Integrar Gmail e Calendar para permitir heartbeats com checagem de email/agenda.
  - [ ] Definir regras de quando o Pola deve avisar (eventos próximos, emails críticos).

- [ ] Tavily Search
  - [ ] Padronizar uso para pesquisas de contexto (mercado, tecnologia, referências).

## 4. Memória e Documentação
- [ ] Enriquecer `OPENCLAW-NOTES.md` com exemplos reais de uso/fluxos.
- [ ] Definir rotina de revisão de memória:
  - [ ] A cada X dias, revisar `memory/YYYY-MM-DD.md` e destilar em `MEMORY.md`.
- [ ] Criar convenções de nomeação para arquivos de documentação adicionais.

## 5. Segurança e Operação
- [x] Rodar periodicamente um healthcheck de gateway/Gmail/Calendar (script `~/openclaw-healthcheck.sh` + cron a cada 5 minutos).
- [ ] Rodar periodicamente um healthcheck de segurança mais amplo (SSH, firewall, updates) usando o skill `healthcheck`.
- [x] Definir limites claros para ações externas (envio de email, posts, etc.) e formalizar em `docs/openclaw-security.md`.

## 6. Experimentos Futuros
- [ ] Explorar agentes especializados (por exemplo: agente de research, agente de finanças pessoais, agente de escrita).
- [ ] Integrar outros canais (WhatsApp, Discord) se fizer sentido na rotina.

---

Este roadmap é um rascunho inicial. A ideia é ir marcando o que for feito, ajustando prioridades e usando o Pola para planejar e executar esses passos junto com o Adriano.