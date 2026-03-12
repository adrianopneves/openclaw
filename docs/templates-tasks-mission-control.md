# Templates de Tasks – Mission Control (v1.0)

> Objetivo: padronizar a criação de tasks em Mission Control para que agentes e humanos falem a mesma "linguagem" ao criar trabalhos.

---

## 1. Template – Projeto Estratégico

**Quando usar:**
- Nova iniciativa importante (produto, oferta, mudança estrutural).

**Campos recomendados:**

- **Title:** `Projeto: <nome>`
- **Description:**
  - **Contexto:** por que isso existe?
  - **Objetivo:** o que significa sucesso?
  - **Critérios de sucesso:** como vamos saber que deu certo?
  - **Restrições:** prazo, recursos, riscos conhecidos.
- **Status inicial:** `inbox`
- **Assignees:** `North Star`, `Sprint`, `Pola`.

**Estados típicos:**
- `inbox` → `assigned` (North Star / Sprint pegam)
- `in_progress` (plano sendo feito, subtarefas criadas)
- `review` (Pola + Adriano decidem)
- `done` (projeto concluído ou arquivado)

---

## 2. Template – Oportunidade / Follow-up

**Quando usar:**
- E-mail relevante de cliente/partner.
- Reunião que gera follow-ups claros.

**Campos recomendados:**

- **Title:** `Follow-up: <Cliente> – <Tema>`
- **Description:**
  - **Origem:** e-mail/reunião + link ou breve transcrição.
  - **Resumo:** o que foi discutido / pedido.
  - **Próximo passo esperado:** o que o outro lado espera.
- **Status inicial:** `inbox`
- **Assignees:** `Deals`, `Sprint` (e `Inbox` quando envolver e-mail).

**Estados típicos:**
- `inbox` (entrada bruta)
- `assigned` (Deals/Sprint assumem)
- `in_progress` (follow-ups em andamento)
- `review` (esperando resposta ou decisão)
- `done` (situação resolvida ou próxima etapa clara em nova task)

---

## 3. Template – Post LinkedIn (Conteúdo)

**Quando usar:**
- Ideias de post, threads, carrosséis para LinkedIn (via Vox/Pola).

**Campos recomendados:**

- **Title:** `Post: <tema>`
- **Description:**
  - **Ideia bruta:** frase ou bloco de texto com o insight central.
  - **Contexto:** público-alvo, objetivo (autoridade, registro, call-to-action).
  - **Formato sugerido:** texto longo, carrossel, lista, etc.
- **Status inicial:** `inbox`
- **Assignees:** `Vox`, `Pola` (e `North Star` se for tema sensível).

**Estados típicos:**
- `inbox` (ideia)
- `in_progress` (rascunhos sendo criados por Vox)
- `review` (Pola + Adriano revisam texto final)
- `in_progress` (após aprovação, até agendar/publicar)
- `done` (post publicado e registrado link e notas)

---

## 4. Template – Rotina / Manutenção de Sistema

**Quando usar:**
- Revisão semanal de projetos, agenda, conteúdo.

**Campos recomendados:**

- **Title:** `Rotina: <tipo> – <período>`
  - Ex.: `Rotina: Revisão de Projetos – Semana 12/2026`.
- **Description:**
  - Escopo da revisão (projetos, agenda, conteúdo, etc.).
  - Checklist de itens a revisar.
- **Status inicial:** `inbox`
- **Assignees:**
  - `Sprint` (projetos), `Agenda` (calendário), `Vox` (conteúdo), `Pola` (consolidação).

**Estados típicos:**
- `inbox` → `in_progress` (checklist sendo executado)
- `done` (quando summary/decisões forem registrados)

---

## 5. Boas práticas gerais

- **1 task = 1 objetivo claro.** Evitar tasks genéricas demais.
- **Sempre escrever contexto suficiente** para outro agente entender sem precisar voltar ao e-mail inteiro.
- **Usar `review` quando há decisão pendente** (principalmente envolvendo Adriano).
- **Fechar tasks com um resumo curto** (o que foi feito, links importantes) antes de marcar `done`.
