# Business Continuity – Sistema de Agentes do Adriano (v1.0)

> Objetivo: garantir que a operação do sistema **não pare** e que a arquitetura **evolua continuamente**, mesmo com falhas técnicas ou períodos de baixa atenção humana.

---

## 1. Princípios de Continuidade

1. **Single point of truth em arquivos e docs**  
   - Arquitetura, autonomia de agentes, cadências e fluxos canônicos documentados em `docs/`.

2. **Degradação graciosa**  
   - Em caso de falha de alguma integração (Google, Buffer, Convex), o sistema continua operando em modo degradado (sem parar tudo).

3. **Observabilidade mínima**  
   - Sempre saber: "o sistema está rodando?" e "o que quebrou?".

4. **Evolução contínua, não revoluções"**  
   - Pequenas melhorias frequentes em vez de redesigns completos raros.

---

## 2. Componentes Críticos

> Regras base: serviços críticos (gateway, Telegram, Gmail/Calendar, Buffer/LinkedIn, Notion) devem ser tratadas como **24x7**. Sempre que possível, desenhar para degradar com graça em vez de parar tudo.

### 2.1. Mapa de serviços 24x7

| Serviço                      | Função principal                                        | Como detecta falha                                         | Como degrada temporariamente                                  |
|------------------------------|--------------------------------------------------------|------------------------------------------------------------|---------------------------------------------------------------|
| OpenClaw Gateway             | Ponte entre agentes, Telegram e skills externas       | `openclaw-healthcheck.sh` / erro na resposta do Pola       | `openclaw-recover.sh`; se persistir, operar só com apps nativos (Gmail, Calendar, Buffer, etc.) |
| Telegram (Pola)              | Canal principal de interação com Adriano              | Falta de respostas / erros sucessivos                      | Usar outro canal temporário (ex.: e-mail) e focar em operação interna (docs)                     |
| Gmail (gog)                  | E-mails (Inbox, follow-ups, notificações)             | Erros do `gog gmail` nos healthchecks                      | Adriano usa Gmail web/app; Inbox atua só em organização interna/MC                               |
| Calendar (gog)               | Agenda e blocos de foco                               | Erros do `gog calendar` nos healthchecks                   | Agenda funciona via interface Google; agentes sugerem ajustes em texto                          |
| Buffer/LinkedIn              | Publicação e agendamento de conteúdo                  | Erros de skills de Buffer / falha ao agendar               | Vox/Pola produzem posts; agendamento/publicação feitos manualmente em Buffer/LinkedIn           |
| Notion                       | Second brain / projetos / conhecimento                | Falhas em skill Notion                                     | Sprint/Notion Brain focam em produzir texto/estruturas; organização é feita depois no Notion    |
| Mission Control (Convex)     | Hub de tasks/mensagens/docs entre agentes             | Falha no skill `mission-control` / incapaz de listar/criar | Usar `MC-FALLBACK-TASKS.md` + Notion para registrar tasks críticas até Convex voltar            |
| Cron / Heartbeats OpenClaw   | Disparar rotinas automáticas (Inbox, Agenda, Vox, etc.) | Heartbeats não aparecem / logs indicam falta de execução | Rodar rotinas manualmente (chamar agentes sob demanda) até cron ser corrigido                   |
| Git / Backup do workspace    | Preservar docs, playbooks e memória em caso de falha   | Falhas em `git status`/`git push` ou backup programado     | Copiar docs críticos para Notion/Drive até restaurar fluxo de versionamento/backup              |


> Regras base: serviços críticos (gateway, Telegram, Gmail/Calendar, Buffer/LinkedIn, Notion) devem ser tratadas como **24x7**. Sempre que possível, desenhar para degradar com graça em vez de parar tudo.


### 2.1. Infraestrutura

- Mac mini com OpenClaw Gateway rodando em background.
- Workspace em `/Users/adrianon/.openclaw/workspace`.
- Scripts:
  - `openclaw-healthcheck.sh` – valida gateway + integrações críticas.
  - `openclaw-recover.sh` – playbook de recuperação.

### 2.2. Camada de Agentes

- Pola (sessão principal) – Chief of Staff, orquestração.
- Agentes de apoio (Vox, Sprint, Inbox, Agenda, etc.) – acessados quando necessário.

### 2.3. Coordenação

- Mission Control (Convex ou backend equivalente) – tasks, messages, docs, notifications.

### 2.4. Ferramentas Externas

- Notion, Buffer/LinkedIn, Gmail, Calendar, etc.

---

## 3. Riscos Principais e Estratégias

### 3.1. Gateway / OpenClaw fora do ar

> Serviço crítico 24x7: impacta diretamente Telegram e qualquer skill que dependa do gateway.


**Risco:** serviços do OpenClaw param de responder; agentes ficam inoperantes.

**Mitigação:**
- `openclaw-healthcheck.sh` em cron a cada 5 minutos:
  - `openclaw gateway status`
  - teste rápido de skill crítico (ex.: `gog` ping, se configurado)
- Em caso de falha:
  - chamar `openclaw-recover.sh`:
    - restart de gateway
    - `openclaw doctor`
    - logs básicos

**Plano B:**
- Em caso de indisponibilidade prolongada:
  - operar com um "modo manual": usar docs em Notion/Google para registrar tasks e decisões até o ambiente ser restaurado.

---

### 3.2. Convex / Mission Control indisponível

**Risco:** perda temporária da camada de tasks/mensagens centralizadas.

**Mitigação:**
- Design dos fluxos sempre com **espelho mínimo local**:
  - para tasks críticas, registrar também em `memory/YYYY-MM-DD.md` ou Notion.
- Em caso de outage:
  - agents passam a registrar decisões e tarefas em arquivos locais ou Notion.

**Plano B:**
- Criar/usar uma "fila local" (arquivo markdown simples) como:
  - `memory/MC-FALLBACK-TASKS.md`.

---

### 3.3. Integrações externas (Gmail, Calendar, Buffer, Notion) quebrando

> Serviços alvo 24x7: objetivo é manter pelo menos leitura/monitoramento contínuos; escrita/ações externas podem degradar para modo manual temporariamente.


**Risco:** agentes Inbox, Agenda, Vox, Sprint deixam de conseguir agir em sistemas externos.

**Mitigação:**
- Healthcheck periódico de integrações críticas (incluído no `openclaw-healthcheck.sh`).
- Registro em `memory/YYYY-MM-DD.md` sempre que uma integração estiver fora.

**Plano B:**
- Em falha de cada integração:
  - **Gmail/Calendar:** usar interfaces padrão (web/app) manualmente até resolver.
  - **Buffer/LinkedIn:** agendar conteúdo manualmente (Gamma/LinkedIn direto).
  - **Notion:** usar app/web; agentes focam em produção de texto e não em escrita via API.

---

### 3.4. Quebra de skill ou skill suspeito

**Risco:** skill instalado via ClawHub com comportamento inseguro ou defeituoso.

**Mitigação:**
- Não instalar skills marcados como "suspicious" sem revisão de código.
- Manter `docs/autonomia-agentes-v1.0.md` e `docs/openclaw-security.md` como referência.

**Plano B:**
- Em caso de problema com um skill:
  - `clawhub uninstall <skill>`.
  - voltar a fluxo manual (ex.: colar texto no Gamma, agendar post direto em Buffer/LinkedIn).

---

## 4. Rotinas de Continuidade (Operação)

### 4.1. Diária (leve)

> Objetivo: garantir que os serviços 24x7 estejam vivos (gateway, integrações principais) sem precisar ficar olhando painel.


- Verificação rápida (por Pola):
  - "Gateway parece OK?" (sem erro ao responder)
  - "Há alguma falha anotada de ontem em memory/YYYY-MM-DD.md?"
- Se houver erro recorrente:
  - sugerir rodar `openclaw-healthcheck.sh`.

### 4.2. Semanal

- Sprint + Pola:
  - Revisão de tasks abertas críticas em Mission Control.
  - Checar se há tarefas paradas por dependência técnica (ex.: integração quebrada).
  - Ajustar prioridades.

- Agenda:
  - Validar que a semana seguinte está coerente com prioridades definidas.

### 4.3. Semanal aprofundado

- Revisão de:
  - `docs/arquitetura-geral-sistema-v1.0.md`.
  - `docs/autonomia-agentes-v1.0.md`.
  - Integridade dos scripts `openclaw-healthcheck.sh` e `openclaw-recover.sh`.

- Decidir:
  - algum agente sobe de nível de autonomia?
  - alguma integração precisa ser reforçada ou substituída?

---

## 5. Continuidade de Evolução (não só de operação)

### 5.1. Registro de melhorias

- Toda vez que uma melhoria estrutural for feita (novo fluxo, novo playbook, mudança de autonomia):
  - Atualizar o doc relevante em `docs/`.
  - Escrever um resumo curto em `memory/YYYY-MM-DD.md`.

### 5.2. Backlog de evolução do sistema

- Manter um backlog de melhorias em:
  - `docs/BACKLOG-SISTEMA-AGENTES.md` (ou no próprio Mission Control), com:
    - ideias de novas integrações
    - ajustes de arquitetura
    - melhorias de segurança/autonomia

### 5.3. Revisão trimestral

- A cada 3 meses:
  - Revisar arquitetura como produto:
    - o que está funcionando muito bem?
    - o que está gerando atrito?
  - Atualizar versão dos docs (v1.1, v1.2, ...).

---

## 6. Procedimento em Caso de Falha Grave

1. **Congelar mudanças externas**  
   - Parar qualquer ação que envolva envio de e‑mails, posts ou alterações de agenda via agentes.

2. **Ativar modo degradação**  
   - Usar ferramentas originais (Gmail, Calendar, LinkedIn, Notion) manualmente.

3. **Rodar recuperação técnica**  
   - Executar `openclaw-recover.sh` no Mac mini.
   - Checar logs de erro mais óbvios.

4. **Registrar incidente**  
   - Documentar em `memory/YYYY-MM-DD.md`:
     - o que aconteceu
     - impacto
     - causa provável (se conhecida)
     - ações tomadas e TODOs

5. **Atualizar arquitetura ou segurança se necessário**  
   - Se a falha revelar um buraco de desenho, corrigir em `docs/`.

---

## 7. Referências

- `docs/arquitetura-geral-sistema-v1.0.md`
- `docs/arquitetura-multi-agentes-mission-control-v1.1.md`
- `docs/autonomia-agentes-v1.0.md`
- `docs/openclaw-security.md`
- Scripts: `openclaw-healthcheck.sh`, `openclaw-recover.sh`
