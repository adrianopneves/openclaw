# MEMORY-POLICY.md
# OpenClaw · Memory Contract v3.0
# Adriano + Pola + North Star
# Baseado em arquitetura CoALA (Working / Episodic / Semantic / Procedural)

---

## ESTRUTURA DE ARQUIVOS

/
├── MEMORY.md ← estado atual do sistema (resumo executivo)
├── MEMORY-POLICY.md ← este arquivo (constituição)
├── MEMORY-INDEX.md ← índice vivo de todos os arquivos ativos
├── MEMORY-WRITE-RULES.md ← quando e como gravar
├── MEMORY-READ-RULES.md ← como recuperar antes de agir
│
├── memory/
│ ├── logs/ ← episodic memory (eventos brutos)
│ │ └── YYYY-MM-DD.md
│ ├── semantic/ ← fatos, preferências, conhecimento consolidado
│ │ ├── PEOPLE.md
│ │ ├── WORK-STRATEGY.md
│ │ ├── LINKEDIN-STRATEGY.md
│ │ ├── NOTION-SYSTEM.md
│ │ └── AGENTS-ARCHITECTURE.md
│ ├── procedural/ ← como operar: playbooks, SOPs, runbooks
│ │ ├── CHIEF_OF_STAFF_PLAYBOOK.md
│ │ ├── LINKEDIN-PLAYBOOK.md
│ │ ├── NOTION-OPERATIONS.md
│ │ └── OPENCLAW-RUNBOOKS.md
│ ├── reviews/ ← consolidação e reflexão semanal
│ │ └── WEEKLY-REVIEW-YYYY-WNN.md
│ └── archive/ ← arquivos deprecados (nunca deletar)
│
└── agents/
 └── <nome>/
 ├── SOUL.md
 ├── IDENTITY.md
 ├── USER.md
 ├── OPERATIONS.md ← procedural memory do agente
 └── CHANGELOG.md ← histórico de mudanças de SOUL/IDENTITY

---

## 01 · AS 4 CAMADAS DE MEMÓRIA

### CAMADA 1 — Working Memory (não persistente)
Contexto ativo da sessão atual. Não salvar automaticamente.
Contém:
- conversa corrente
- tarefa em andamento
- checklist corrente
- hipóteses e decisões provisórias

Regra: working memory não vira MEMORY.md por padrão.
Só persiste se passar pelo critério de gravação abaixo.

---

### CAMADA 2 — Episodic Memory
Onde: memory/logs/YYYY-MM-DD.md
O quê: eventos, decisões, problemas, aprendizados — o que aconteceu, quando, com qual resultado.

Formato obrigatório de entrada:

## YYYY-MM-DD HH:MM
Type: decision | change | problem | learning | creation
Topic: [tema]
Summary: [o que aconteceu / foi decidido]
Impact: [consequência prática]
Follow-up: [próximo passo, se houver]
Status: draft | confirmed
Tags: [tag1, tag2]

Cabeçalho do arquivo:
# YYYY-MM-DD · [tema principal] · status: aberto | consolidado

---

### CAMADA 3 — Semantic Memory
Onde: memory/semantic/
O quê: fatos estáveis, preferências consolidadas, conhecimento que permanece válido.

Regra crítica: semantic memory não é escrita diretamente da conversa crua.
Ela nasce da consolidação dos logs episódicos.

Estrutura interna de cada arquivo semântico:
- Bloco "Última atualização" no topo
- Seção "Estado atual / Decisões vigentes" (separada do histórico)
- Tags inline: [CRÍTICO] = nunca ignorar | [CONTEXTO] = background

Arquivos ativos:
- PEOPLE.md, WORK-STRATEGY.md, LINKEDIN-STRATEGY.md, NOTION-SYSTEM.md, AGENTS-ARCHITECTURE.md

---

### CAMADA 4 — Procedural Memory
Onde: memory/procedural/ e agents/<nome>/OPERATIONS.md
O quê: como operar. Playbooks, SOPs, runbooks, rotinas, fluxos de decisão.

Distinção importante:
- SOUL.md = princípios (não é procedural)
- IDENTITY.md = papel (não é procedural)
- USER.md = contexto do usuário (não é procedural)
- OPERATIONS.md / PLAYBOOKS = procedural memory ← aqui sim

Regra de versionamento: bloco "## Versão atual" no topo de cada playbook,
separado do histórico. Agente sempre lê só a versão atual.

---

## 02 · QUANDO GRAVAR — REGRAS BINÁRIAS

Gravar em memory/logs/ se ocorreu qualquer um destes:
- decisão relevante
- mudança em ativo, agente ou fluxo
- problema identificado
- aprendizado novo
- criação ou edição de arquivo de sistema

Promover para semantic ou procedural se:
- o item seguirá válido por mais de 2 semanas
- impacta comportamento futuro
- evita retrabalho
- altera a forma padrão de operar

Filtro de "peso mínimo":
→ "Isso ainda será relevante em 2 semanas?"
Se sim → gravar. Se não → log diário apenas.

NÃO gravar em arquivos permanentes:
- contexto temporário de sessão
- explorações descartadas
- informações que mudam em dias
- instruções one-shot sem recorrência

Granularidade mínima de cada gravação:
- o quê mudou + por quê (contexto mínimo) + quando
Sem esse tripé, a entrada vira ruído.

---

## 03 · CONFIANÇA DA MEMÓRIA

Todo registro deve ter um status explícito:
- draft → registrado, ainda não validado
- confirmed → validado e em uso
- superseded → substituído por versão mais recente
- archived → inativo, movido para memory/archive/

Regra: agente nunca usa registro com status superseded ou archived como verdade atual.

---

## 04 · COMO RECUPERAR (READ RULES)

Sequência obrigatória antes de agir em tema recorrente:
1. Classificar o pedido (qual camada é relevante?)
2. Mapear quais arquivos consultar
3. Abrir só os arquivos relevantes
4. Ler só a seção "Estado atual / Decisões vigentes"
5. Responder em cima da memória + contexto atual

Regras adicionais:
- Nunca reler a memória inteira. Recuperação seletiva sempre.
- Se arquivo consultado estiver desatualizado: sinalizar antes de responder.
 "Minha memória de [X] data de [data] e pode estar desatualizada. Confirma ou atualizo?"
- Memória como contexto, não como lei. Adriano sempre pode sobrescrever.

---

## 05 · TIMING DE GRAVAÇÃO

1. Gravar no momento — não ao fechar sessão.
2. Gravar o que foi decidido mesmo que o assunto continue.
3. Automático — não depende de "grava isso" do Adriano.
4. Confirmar gravações críticas — para SOUL.md, IDENTITY.md ou MEMORY.md:
 emitir confirmação: "Gravado em [arquivo] — alteração: [X]."
5. Sinalizar conflito antes de sobrescrever:
 "Isso conflita com [X] em [arquivo]. Substituir, mesclar ou manter os dois?"

---

## 06 · CONSOLIDAÇÃO E REFLEXÃO

### Ciclo semanal — Pola + North Star
1. Revisar logs da semana em memory/logs/
2. Extrair: fatos permanentes, preferências estáveis, regras novas, decisões estruturais
3. Atualizar: MEMORY.md, arquivos semantic/, playbooks procedural/
4. Marcar logs processados com status: consolidado
5. Atualizar MEMORY-INDEX.md
6. Executar reflexão (ver abaixo)
7. Salvar review em memory/reviews/WEEKLY-REVIEW-YYYY-WNN.md

### Reflexão (Pola + North Star)
Prospective: "O que precisamos lembrar para agir melhor na próxima vez?"
Retrospective: "O que aprendemos com o que aconteceu nesta semana?"

### Gatilhos de consolidação imediata (não esperar o ciclo):
- Tema acumulou 3+ referências em logs sem arquivo temático próprio → criar arquivo
- Decisão antiga está sendo contradita → resolver e atualizar imediatamente

---

## 07 · DEPRECAÇÃO E PRUNING

Regras de limpeza:
- Arquivo temático sem atualização em 60 dias → mover para memory/archive/ com nota de data
- Nunca deletar — só arquivar
- Remover duplicatas durante consolidação semanal
- Marcar informação substituída como status: superseded antes de arquivar
- Manter versão atual + histórico resumido (não histórico completo inline)

---

## 08 · TABELA DE ROTEAMENTO

| Tipo de informação | Arquivo destino | Histórico / backup |
|-------------------------------------|----------------------------------------------|----------------------------------|
| Estado atual do sistema | MEMORY.md | — |
| Evento / decisão do dia | memory/logs/YYYY-MM-DD.md | Consolidar semanal |
| Perfil de Adriano | USER.md (raiz) | — |
| Pessoas importantes (terceiros) | memory/semantic/PEOPLE.md | memory/people/<nome>.md se crescer |
| Estratégia de trabalho | memory/semantic/WORK-STRATEGY.md | — |
| Estratégia LinkedIn | memory/semantic/LINKEDIN-STRATEGY.md | Log diário |
| Arquitetura Notion | memory/semantic/NOTION-SYSTEM.md | — |
| Decisões de arquitetura de agentes | memory/semantic/AGENTS-ARCHITECTURE.md | Log diário |
| Playbooks e SOPs | memory/procedural/ | Bloco "Versão atual" no topo |
| Identidade / comportamento agente | agents/<nome>/IDENTITY.md + SOUL.md | agents/<nome>/CHANGELOG.md |
| Regras operacionais de agente | agents/<nome>/OPERATIONS.md | — |
| Review semanal | memory/reviews/WEEKLY-REVIEW-YYYY-WNN.md | — |

---

## 09 · REGRAS CENTRAIS (resumo executivo para Pola)

Regra 1: Toda decisão relevante entra primeiro em episódica (memory/logs/).
Regra 2: Nada vira memória estável sem consolidação explícita.
Regra 3: Playbook é procedural, não semantic.
Regra 4: Antes de agir, recuperar só o necessário — nunca ler tudo.
Regra 5: Toda semana revisar, consolidar, refletir, podar e atualizar estado atual.
Regra 6: Todo registro tem status. Agente nunca usa superseded como verdade.
Regra 7: Mudança em SOUL/IDENTITY → registrar em CHANGELOG.md do agente.
Regra 8: Conflito detectado → sinalizar antes de sobrescrever, nunca silencioso.

---
_Memory Contract v3.0 · supersede v2.0 · aplicar imediatamente_
