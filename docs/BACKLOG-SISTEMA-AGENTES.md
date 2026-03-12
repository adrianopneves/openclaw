# Backlog – Sistema de Agentes do Adriano

> Lista viva de melhorias e evoluções do sistema de agentes, Mission Control e integrações.

Formato sugerido: uma linha por item.

Colunas: **[Ideia] [Agente(s)] [Complexidade] [Prioridade] [Notas]**

---

## Itens iniciais

1. **Integração segura com Gamma.app via skill dedicado**  
   - Agentes: Gamma, Pola  
   - Complexidade: média  
   - Prioridade: alta  
   - Notas: revisar skill `gamma` do ClawHub (código, endpoints, segurança) antes de qualquer instalação.

2. **Heartbeat de e-mail para conta corporativa (Adriano.neves@avanade.com)**  
   - Agentes: Inbox, Pola  
   - Complexidade: média  
   - Prioridade: alta  
   - Notas: usar `gog` para checks periódicos; definir VIPs e regras de alerta.

3. **Painel de estado do sistema (health dashboard)**  
   - Agentes: Pola, Sprint  
   - Complexidade: média  
   - Prioridade: média  
   - Notas: consolidar em um lugar: status gateway, integrações (Gmail, Calendar, Buffer), últimas falhas.

4. **Playbooks dos demais agentes (Inbox, Agenda, Notion Brain, Deals, Storyline, Research)**  
   - Agentes: todos  
   - Complexidade: baixa–média (cada)  
   - Prioridade: média  
   - Notas: seguir modelo de Vox e Sprint.

5. **Configuração e teste real de Mission Control (Convex)**  
   - Agentes: todos  
   - Complexidade: alta  
   - Prioridade: alta  
   - Notas: implementar schema descrito em `arquitetura-multi-agentes-mission-control-v1.1.md` e testar fluxos.

6. **Heartbeats básicos por agente (fase 2 do roadmap)**  
   - Agentes: Vox, Sprint, Agenda, Inbox  
   - Complexidade: média  
   - Prioridade: média  
   - Notas: começar com sugestões e atualizações internas, sem ações externas automáticas.

7. **Relatório mensal automático de conteúdo (Vox)**  
   - Agentes: Vox, Pola  
   - Complexidade: baixa–média  
   - Prioridade: baixa–média  
   - Notas: consolidar posts publicados, temas fortes, oportunidades de aprofundar.
