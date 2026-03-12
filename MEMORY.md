# MEMORY.md

## Arquitetura Multi-Agentes / Criação e Gestão de Agentes
- Existe uma documentação técnica chamada "Arquitetura Multi-Agentes com OpenClaw – Mission Control" (versão 1.1, março 2026), em `docs/arquitetura-multi-agentes-mission-control-v1.1.md`, descrevendo a arquitetura de um squad de ~10 agentes, cada um como sessão independente com SOUL, memória em arquivos, heartbeats e acesso compartilhado ao Mission Control (Convex).
- Para qualquer decisão de criação, papel, fluxo, autonomia ou coordenação entre agentes, essa documentação é a referência principal.
- Conceitos-chave: Gateway 24/7, sessões/agentes com SOUL.md e AGENTS.md, sistema de memória em arquivos (workspace), heartbeats a cada ~15min, Mission Control em Convex (tarefas, comentários, notificações), níveis de autonomia e boas práticas de squad.
- Squad atual materializado no workspace: Pola (Chief of Staff), Vox (LinkedIn), Sprint (Execução/Notion), North Star (Estratégia), Storyline (Apresentações), Inbox (E-mails/Mensagens), Agenda (Calendário/Energia), Notion Brain (Arquitetura Notion/PARA), Deals (Pipeline/Oportunidades) e Research (Pesquisa/Radar), cada um com pasta `agents/<nome>/` e arquivos de identidade/operação.

## Roadmap Multi-Agentes (Mar 2026)
- Fases definidas para ativação do squad:
  - Fase 0: inventário de agentes, papéis, rotinas semanais e limites (no overlap entre Vox/Sprint/Notion Brain etc.).
  - Fase 1: operação guiada de 3 agentes core (Pola, Vox, Sprint) sem autonomia externa, focando em conteúdo, projetos e orquestração.
  - Fase 2: heartbeats leves por agente (Vox, Sprint, Agenda), apenas sugerindo ações e atualizando Mission Control, sem publicar nem enviar nada sozinho.
  - Fase 3: integração plena com Mission Control (Convex) como fonte única de tarefas/estado/comentários entre agentes.
  - Fase 4: autonomia gradual por agente (níveis 1–3) com guardrails claros, começando por Vox/Sprint.
- Itens de infraestrutura que ainda precisam ser consolidados: schema do Mission Control em Convex, skill/integração com Buffer (modo rascunho), identidades/pastas por agente e definição de heartbeats e níveis de autonomia por agente.
- Modelo de segurança do OpenClaw definido em `docs/openclaw-security.md`, incluindo: camadas de identidade/acesso, gestão de segredos, hardening do Mac mini, níveis de autonomia por agente e playbook de incidentes (vazamento de tokens, quebras de integração, etc.).
- Scripts operacionais criados para robustez do gateway e integrações Google: `~/openclaw-healthcheck.sh` (cron a cada 5 minutos) e `~/openclaw-recover.sh` (recuperação manual), que devem ser usados sempre que houver suspeita de problema com gateway/Gmail/Calendar.
