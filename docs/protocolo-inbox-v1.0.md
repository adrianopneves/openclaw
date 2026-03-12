# Protocolo Inbox – Monitoramento e Alertas de E-mail (v1.0)

> Objetivo: definir como o agente Inbox deve se comportar ao monitorar e-mails e quando deve avisar o Adriano.

---

## 1. Contas monitoradas

- Primária (trabalho): `Adriano.neves@avanade.com`  
- Outras contas podem ser adicionadas conforme configuração.

---

## 2. Classificação de e-mails

Cada e-mail novo deve ser classificado em uma das três categorias:

1. **Ação necessária (ALTA)**
   - Remetentes VIP (chefes, diretoria, clientes chave, esposa, etc.).
   - Solicita decisão, resposta, aprovação, marcação de reunião.
   - Relacionado a projetos/temas críticos.

2. **Informativo (MÉDIA)**
   - Atualizações relevantes mas sem ação imediata.
   - Relatórios, newsletters de alto valor, comunicados internos importantes.

3. **Ruído (BAIXA)**
   - Promoções, notificações automáticas irrelevantes, spam.

---

## 3. Quem é VIP (inicial)

A ser preenchido na prática, exemplos:
- Lizete (assuntos pessoais importantes).
- Chefes diretos na Avanade.
- Alguns clientes estratégicos.

> Este bloco deve ser refinado assim que a lista real for definida.

---

## 4. Quando avisar o Adriano

Inbox deve **avisar proativamente** (via Pola) quando:

1. Chegar um e-mail **ALTA** de alguém VIP ou sobre tema crítico.  
2. Chegar um e-mail com **prazo explícito** ("até hoje", "urgente").  
3. Houver **acúmulo de pendências** em um mesmo tópico (ex.: 2–3 follow-ups sem resposta).

Formato de aviso:

- Resumo curto (remetente, assunto, 1–2 frases do que é pedido).
- Sugestão de próxima ação (ex.: responder X, marcar reunião Y).

Se não houver nada importante, Inbox **não fala nada**.

---

## 5. Frequência de monitoramento

- Ideal: check a cada **5–15 minutos** via heartbeat/cron.
- Em horários de baixa prioridade (noite/madrugada), checks podem ser menos frequentes ou silenciosos.

---

## 6. Integração com Mission Control

Quando um e-mail exige ação:

- Criar task "Follow-up: <Remetente> – <Tema>".
- Incluir:
  - resumo do e-mail,
  - o que é esperado,
  - prazo, se houver.

Deals, Sprint, Agenda ou Pola assumem a partir daí, conforme o tipo da ação.
