# Implementação do Mission Control – Esboço Técnico (v1.0)

> Objetivo: descer da arquitetura conceitual para um plano de implementação prática do Mission Control (provavelmente em Convex).

---

## 1. Stack sugerida

- Backend: **Convex** (ou serviço similar com tabelas reativas).
- Frontend: painel leve (pode ser web simples ou Notion/API como primeira visualização).
- Integração com OpenClaw: via skill dedicado (ex.: `mission-control`) para CRUD de tasks/messages/documents.

---

## 2. Tabelas principais (Convex)

- `agents`  
  Campos: `id`, `name`, `role`, `status`, `sessionKey`.

- `tasks`  
  Campos: `id`, `title`, `description`, `status`, `assigneeIds`, `createdAt`, `updatedAt`, `dueDate`, `parentId`.

- `messages`  
  Campos: `id`, `taskId`, `fromAgentId`, `content`, `createdAt`, `mentions`.

- `documents`  
  Campos: `id`, `taskId`, `title`, `content`, `type`, `createdAt`.

- `notifications`  
  Campos: `id`, `mentionedAgentId`, `taskId`, `messageId`, `delivered`, `createdAt`.

- `activities`  
  Campos: `id`, `type`, `agentId`, `taskId`, `message`, `createdAt`.

---

## 3. Fluxos técnicos

### 3.1. Criação de task por agente

1. Agente (via OpenClaw) chama skill `mission-control`:
   - `createTask(title, description, assigneeIds, parentId?)`.
2. Convex cria registro em `tasks`.
3. Registro em `activities` do tipo `task_created`.

### 3.2. Mensagens e @mentions

1. Agente cria mensagem ligada a uma task:
   - `createMessage(taskId, fromAgentId, content)`.
2. Serviço extrai `@AgentName` de `content` e cria entradas em `notifications`.
3. Um worker/daemon lê `notifications` não entregues e usa `sessions_send` para avisar sessões dos agentes.

---

## 4. Skill Mission Control para OpenClaw

Criar skill (ex.: `skills/mission-control/`) com comandos:

- `mc task create` – cria task.
- `mc task update-status` – muda status.
- `mc message add` – adiciona mensagem.
- `mc doc upsert` – cria/atualiza documento.
- `mc notifications fetch` – busca notificações pendentes.

Esta parte é apenas esboço; implementação real exige setup do Convex, schema e código.

---

## 5. Fases de implementação

1. **MVP local**  
   - Tasks e mensagens em arquivo JSON simples para testar fluxos.

2. **Convex beta**  
   - Subir schema básico em Convex.
   - Criar skill mínimo de leitura/escrita.

3. **Integração total**  
   - Substituir JSON local por Convex.
   - Adicionar notificações e activities.

---

Este documento é um ponto de partida técnico; detalhes serão refinados quando for hora de realmente codar o Mission Control.
