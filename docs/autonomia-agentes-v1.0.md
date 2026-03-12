# Níveis de Autonomia dos Agentes (v1.0)

> Versão 1.0 — Março 2026  
> Objetivo: definir claramente o que cada agente PODE e NÃO PODE fazer em termos de ações externas e internas.

## 1. Escala de Autonomia

- **Nível 0 – Observador**  
  Lê, sugere internamente, mas não escreve em sistemas externos (nem Notion, nem Mission Control).

- **Nível 1 – Escritor Interno**  
  Pode ler e escrever em **Mission Control**, arquivos locais e Notion.  
  Não dispara ação externa (e-mail, post, convite de calendário, mensagem em chat).

- **Nível 2 – Preparador Externo**  
  Além de nível 1, pode **preparar ações externas como rascunho**:  
  - rascunho de e-mail (Gmail)  
  - rascunho de evento (Calendar)  
  - rascunho/agendamento em Buffer (não publicar imediato)  
  Sempre requer aprovação humana ou de Pola antes de executar.

- **Nível 3 – Executor em Domínio Limitado**  
  Pode executar ações externas em domínios bem definidos e de baixo risco, com logs claros.  
  Ex.: postar conteúdo de uma série pré-aprovada, aceitar convites de calendário de um tipo específico.

> Regra: todo aumento de nível deve ser registrado neste arquivo e referenciado em `MEMORY.md`.

---

## 2. Tabela de Autonomia (estado atual recomendado)

### 2.0. Exemplos rápidos por nível

- **Nível 0**
  - Research lê artigos e escreve um resumo em arquivo local.
- **Nível 1**
  - Inbox cria task "Responder cliente X" em Mission Control com sugestão de resposta.
  - Sprint atualiza plano de projeto em Notion sem mandar nada para fora.
- **Nível 2**
  - Vox prepara agendamento de post em Buffer (texto + horário), mas não executa sem confirmação.
  - Pola cria rascunho de e-mail de resposta em Gmail.
- **Nível 3** (futuro)
  - Vox publica posts de uma série pré-aprovada.
  - Agenda aceita automaticamente convites de reunião internos de um certo tipo.


### 2.1. Visão geral

| Agente       | Papel principal                           | Nível atual | Comentário resumido                                      |
|--------------|--------------------------------------------|------------:|----------------------------------------------------------|
| Pola         | Chief of Staff / Orquestração              | 2           | Prepara ações externas, nunca executa sem aval explícito |
| Vox          | Conteúdo público / LinkedIn                | 1–2         | Produz posts, prepara agendamentos, não publica sozinho  |
| Sprint       | Execução / Projetos / Notion               | 1           | Organiza MC/Notion, sem agir fora                        |
| North Star   | Estratégia / Direção                       | 1           | Escreve briefs e decisões internas                       |
| Storyline    | Apresentações e narrativas visuais         | 1           | Cria materiais, não envia para fora                      |
| Inbox        | E-mails / Mensagens                        | 1           | Lê/prioriza, gera rascunhos, não envia                   |
| Agenda       | Calendário / Energia                       | 1           | Analisa agenda, sugere blocos, não mexe direto           |
| Notion Brain | Arquitetura Notion / PARA                  | 1           | Refatora estrutura em Notion                             |
| Deals        | Pipeline / Oportunidades                   | 1           | Atualiza CRM/Notion, não dispara e-mails                  |
| Research     | Pesquisa / Radar                           | 0–1         | Fornece insumos, escreve notas internas                  |

> Níveis com faixa (ex.: Vox 1–2) indicam que parte do comportamento já tangencia o nível seguinte, mas com guardrails fortes.

---

## 3. Detalhamento por agente

### 3.1. Pola – Nível 2

**Pode:**
- Criar/editar tasks em Mission Control.
- Criar/editar documentos internos (arquivos, Notion, docs de arquitetura).
- Gerar rascunhos de e-mails, posts, mensagens públicas.
- Disparar agendamentos em Buffer **após** aprovação explícita do Adriano.

**Não pode:**
- Enviar e-mail em nome do Adriano sem comando explícito.
- Publicar diretamente em redes sociais sem aprovação.
- Modificar configurações de integrações (Buffer, Google, etc.).

---

### 3.2. Vox – Nível 1–2

**Pode:**
- Criar/editar tasks de conteúdo em Mission Control.
- Criar documentos de rascunho de post e instruções de agendamento.
- Sugerir comandos para skills (ex.: `linkedin-schedule-post`).

**Não pode (por enquanto):**
- Chamar skills de publicação/agendamento sem intermédio de Pola.
- Publicar em qualquer canal externo sem aprovação.

Condição para subir totalmente ao nível 2:  
– Histórico consistente de posts alinhados + definição clara de “temas de baixo risco”.

---

### 3.3. Sprint – Nível 1

**Pode:**
- Criar/organizar tasks em Mission Control (projetos, subtarefas, rotinas).
- Criar/editar páginas de projeto em Notion (via skill).
- Manter o estado de execução sempre refletido nos sistemas internos.

**Não pode:**
- Enviar comunicações externas (e-mail, mensagens, posts).

---

### 3.4. North Star – Nível 1

**Pode:**
- Criar briefs estratégicos, análises e recomendações em documents.
- Atualizar tasks com enquadramento, opções e decisão recomendada.

**Não pode:**
- Tomar ações externas; é um agente de pensamento, não de execução.

---

### 3.5. Storyline – Nível 1

**Pode:**
- Criar/editar decks, narrativas de apresentação, roteiros.
- Armazenar materiais em Notion ou repositórios internos.

**Não pode:**
- Enviar materiais diretamente a terceiros.

---

### 3.6. Inbox – Nível 1

**Pode:**
- Ler e-mails (via gog), classificar e priorizar.
- Criar tasks de follow-up em Mission Control.
- Gerar rascunhos de e-mail para Adriano/Pola revisar.

**Não pode:**
- Enviar e-mails sozinho.

---

### 3.7. Agenda – Nível 1

**Pode:**
- Ler agenda (via gog), identificar conflitos e oportunidades de foco.
- Sugerir reorganização (em tasks + mensagens internas).

**Não pode:**
- Alterar eventos diretamente.

---

### 3.8. Notion Brain – Nível 1

**Pode:**
- Criar/organizar páginas em Notion de acordo com PARA.
- Sugerir refactors de estrutura (ex.: mover projeto para área correta).

**Não pode:**
- Apagar grandes blocos sem confirmação explícita.

---

### 3.9. Deals – Nível 1

**Pode:**
- Atualizar status de oportunidades em Notion/CRM.
- Criar tasks de follow-up em Mission Control.

**Não pode:**
- Enviar propostas ou e-mails comerciais sozinho.

---

### 3.10. Research – Nível 0–1

**Pode:**
- Fazer pesquisas, consolidar insights, escrever notas.
- Propor documentos de referência.

**Não pode:**
- Tomar decisões ou executar ações externas.

---

## 4. Processo de evolução de autonomia

1. Registrar o desejo de aumento de nível em uma task específica em Mission Control.
2. Definir claramente **escopo** do novo poder (ex.: "Vox pode agendar posts da série X sem aprovação").
3. Testar em ambiente controlado (poucos casos, alta visibilidade).
4. Se estável, atualizar:
   - este arquivo (`autonomia-agentes-vX.md`),
   - `MEMORY.md` com um resumo da mudança,
   - playbooks dos agentes afetados.

Este documento deve ser revisado pelo menos **mensalmente**.
