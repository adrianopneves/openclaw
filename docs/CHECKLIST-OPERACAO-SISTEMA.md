# Checklist de Operação do Sistema de Agentes

> Uso prático: abrir este arquivo quando quiser saber se o sistema está saudável ou quando algo parecer estranho.

---

## 1. Check rápido (no dia a dia)

1. Você manda mensagem para o Pola (Telegram) → **resposta vem normal?**
2. Existem pelo menos 2 posts em rascunho e 1–2 prontos para agendar (Vox)?
3. Projetos importantes aparecem como tasks claras (não só em conversa solta)?

Se a resposta for "não" para algum item, considerar rodar o healthcheck.

---

## 2. Check diário (2–5 minutos)

1. Perguntar para o Pola:
   - "Teve alguma falha técnica registrada ontem/hoje?"
2. Se houver sintoma estranho (erro recorrente, demora, falha de integração):
   - Rodar no Mac mini: `openclaw-healthcheck.sh`.
   - Seguir as instruções/impressões do script.

---

## 3. Check semanal

### 3.1. Sistema (Sprint + Agenda + Pola)

- Sprint:
  - Revisar projetos `in_progress` em Mission Control / Notion.
  - Ver se cada projeto tem próximo passo claro.
- Agenda:
  - Revisar próximos 7 dias de calendário.
  - Identificar conflitos e blocos de foco.
- Pola:
  - Consolidar um resumo curto para Adriano com:
    - principais frentes em andamento;
    - pendências que exigem decisão.

### 3.2. Conteúdo (Vox + Pola)

- Confirmar:
  - 3–5 ideias de post em pipeline.
  - 2 rascunhos ativos.
  - 1–2 prontos para agendar via Buffer.

---

## 4. Check semanal aprofundado

1. Revisar arquitetura e autonomia:
   - `docs/arquitetura-geral-sistema-v1.X.md`
   - `docs/autonomia-agentes-v1.X.md`
2. Ver se algum agente pode subir 1 nível de autonomia.
3. Revisar continuidade:
   - `docs/business-continuity-sistema-agentes-v1.0.md`
   - Scripts `openclaw-healthcheck.sh` e `openclaw-recover.sh` ainda fazem sentido?
4. Conteúdo:
   - Vox gera mini-relatório (posts, temas fortes, oportunidades).

1. Revisar arquitetura e autonomia:
   - `docs/arquitetura-geral-sistema-v1.X.md`
   - `docs/autonomia-agentes-v1.X.md`
2. Ver se algum agente pode subir 1 nível de autonomia.
3. Revisar continuidade:
   - `docs/business-continuity-sistema-agentes-v1.0.md`
   - Scripts `openclaw-healthcheck.sh` e `openclaw-recover.sh` ainda fazem sentido?
4. Conteúdo:
   - Vox gera mini-relatório mensal (posts, temas fortes, oportunidades).

---

## 5. Em caso de falha

### 5.1. Se Pola/Telegram parar de responder direito

1. No Mac mini:
   - Rodar: `openclaw-healthcheck.sh`.
2. Se não resolver:
   - Rodar: `openclaw-recover.sh`.
3. Se continuar com problema:
   - Registrar incidente em `memory/YYYY-MM-DD.md`.
   - Operar manualmente e avisar o Pola quando ele voltar.

### 5.2. Se Gmail/Calendar integrações quebrarem

- Usar Gmail/Calendar web/app manualmente.
- Manter agentes Inbox/Agenda operando apenas como apoio interno (priorização, rascunhos).

### 5.3. Se Buffer/LinkedIn integrações quebrarem

- Fluxo de conteúdo segue até texto final aprovado.
- Último passo (agendamento/publicação) é feito manualmente no Buffer/LinkedIn.

---

## 5. Check mensal profundo

1. Revisão completa da arquitetura (técnica e operacional):
   - validar se `arquitetura-geral-sistema` e `arquitetura-multi-agentes-mission-control` ainda refletem a realidade;
   - revisar se cadências semanais estão funcionando na prática.
2. Revisão de autonomia:
   - olhar histórico de comportamentos dos agentes;
   - decidir promoções/rebaixamentos de autonomia com base em evidência.
3. Revisão de riscos e continuidade:
   - reavaliar business continuity, pontos únicos de falha, skills sensíveis (ex.: Gamma);
   - ajustar scripts de healthcheck/recover se necessário.
4. Revisão de impacto:
   - o sistema de agentes está de fato reduzindo carga cognitiva e acelerando execução?

---

## 6. Hábitos mínimos de evolução

1. Sempre que houver mudança estrutural (novo fluxo, agente, autonomia):
   - Atualizar o doc correspondente em `docs/`.
2. Sempre que houver incidente relevante:
   - Registrar em `memory/YYYY-MM-DD.md`:
     - o que aconteceu,
     - impacto,
     - como foi resolvido,
     - o que será ajustado.

Esse checklist deve ser revisado e ajustado conforme o sistema evoluir.
