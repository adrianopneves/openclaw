# Modelo de Segurança para OpenClaw (Mac mini do Adriano)

Este documento define como o OpenClaw deve operar com segurança na sua máquina pessoal (Mac mini), com foco em:
- minimizar risco de vazamento de segredos
- reduzir impacto se algo vazar
- manter o sistema estável e recuperável

Estrutura em 5 camadas:
1. Identidade e acesso
2. Segredos (tokens, API keys)
3. Host (Mac mini)
4. OpenClaw e agentes
5. Incidentes e rotinas

---

## 1. Identidade e acesso

**Objetivo:** saber "quem é quem" e limitar o dano se algo comprometer uma conta.

### 1.1. Separação de identidades

- Manter separação clara entre:
  - **Conta pessoal** (Adriano) e **contas de assistente** (ex: `pola.agentic@gmail.com`).
  - Bots e integrações (Telegram bot, Notion integration, Buffer app, etc.) sempre com identidade própria.
- Sempre que possível, usar contas dedicadas para integrações do assistente, não a conta pessoal principal.

### 1.2. Acesso ao Mac mini

- Usuário com **senha forte** e **FileVault ativado** (disco criptografado).
- Se houver acesso remoto:
  - Usar somente canais seguros (SSH com chave, Tailscale/VPN, etc.).
  - Evitar exposição direta de portas na internet.
- OpenClaw gateway preferencialmente escutando em `localhost` ou protegido via túnel/autenticação.

### 1.3. Sessão de chat (Telegram)

- Tratar o Telegram como canal privilegiado, mas **não confiável para segredos**:
  - Não colar tokens completos ou senhas.
  - Quando necessário, referenciar apenas de forma mascarada (ex: `sk-abc123...xyz`).
  - Considerar qualquer segredo que tenha aparecido no chat como potencialmente comprometido.

---

## 2. Segredos (tokens, API keys, senhas)

**Objetivo:** minimizar impacto de vazamento e evitar exposição acidental.

### 2.1. Armazenamento

- Segredos devem residir em:
  - Arquivos `.env` locais (fora de controle de versão).
  - Campos apropriados do `openclaw.json` apenas quando estritamente necessário.
- Nunca commitar segredos em git, nem deixá-los em arquivos compartilhados.

### 2.2. Princípio do menor privilégio

- Notion:
  - Integração com escopos mínimos (apenas bases/páginas que o assistente realmente precisa).
- Buffer:
  - Apenas permissões necessárias para criar/editar rascunhos, evitando escopos mais amplos quando possível.
- Google (Gmail/Calendar):
  - Usar conta dedicada do assistente (`pola.agentic`) em vez de conta pessoal.

### 2.3. Manipulação

- Não colar tokens ou credenciais completas no chat.
- Evitar comandos que imprimam segredos em logs, como:
  - `env`, `printenv` quando há variáveis sensíveis.
  - comandos que exibem `.env` ou arquivos de config com tokens.
- Se for necessário inspecionar configs, preferir exibir apenas partes não sensíveis.

### 2.4. Rotação de segredos

- Qualquer segredo que tenha aparecido em:
  - chat (Telegram, etc.),
  - logs copiados,
  - prints de tela compartilhados,
  deve ser considerado comprometido e **rotacionado**.

- Playbook mínimo para rotação:
  1. **Identificar** quais tokens/keys foram expostos (Telegram, Buffer, Notion, Tavily, gateway, etc.).
  2. **Rotacionar/revogar** na origem (console do serviço).
  3. **Atualizar** `.env`/`openclaw.json` no Mac mini com os novos valores.
  4. **Testar** com:
     - `openclaw doctor`
     - `openclaw channels status --probe`
     - testes específicos das skills (Gmail, Calendar, Notion, Buffer).

---

## 3. Host (Mac mini)

**Objetivo:** reduzir a probabilidade de comprometimento do host e limitar impacto se ele for acessado.

### 3.1. Sistema operacional

- Manter o macOS atualizado, com updates de segurança automáticos ativados.
- FileVault ligado (criptografia de disco) para proteger dados em repouso.
- Evitar uso desnecessário de privilégios elevados (root/admin) para tarefas rotineiras.

### 3.2. OpenClaw

- Instalação e atualização sempre via instalador oficial:

  ```bash
  curl -fsSL https://openclaw.ai/install.sh | bash -- --no-onboard
  ```

- Manter o LaunchAgent do gateway ativo para garantir restart automático.
- Usar o checklist de update seguro em `docs/openclaw-update-checklist.md` antes/depois de atualizar:
  - backup de `openclaw.json`,
  - `openclaw status`,
  - `openclaw gateway status`,
  - `openclaw doctor`,
  - `openclaw channels status --probe`.

### 3.3. Monitoramento contínuo

- Script `~/openclaw-healthcheck.sh` agendado no `cron` a cada 5 minutos:
  - verifica saúde do gateway,
  - reinicia se necessário,
  - roda smoke tests de `gog` (Gmail/Calendar).
- Logs em caso de problema:
  - `openclaw logs --follow` para acompanhar comportamento do gateway.

### 3.4. Exposição de rede

- Ideal: gateway escutando apenas em `localhost`.
- Se usar túneis (Tailscale, etc.):
  - considerar esses canais como infra sensível,
  - evitar exposição pública sem autenticação forte.

---

## 4. OpenClaw e agentes

**Objetivo:** controlar o que cada agente pode fazer e o que ele enxerga.

### 4.1. Sessão principal (Pola)

- Pola é o "Chief of Staff" digital, com acesso ampliado, mas ainda sob limites:
  - Confirmações explícitas para ações destrutivas (ex: remoção recursiva, alterações irreversíveis).
  - Cautela ao enviar qualquer coisa que represente Adriano externamente (e-mails, posts, mensagens públicas).

### 4.2. Skills

- Instalar apenas skills necessárias, reduzindo a superfície de ataque.
- Para skills que interagem com o mundo externo (Gmail, Calendar, Notion, Buffer):
  - usar contas/integrações dedicadas,
  - conceder apenas os escopos mínimos.

### 4.3. Multi-agente e níveis de autonomia

- Cada agente com pasta própria (`agents/<nome>/`) e `SOUL.md`/`IDENTITY.md` dedicados.
- Definir níveis de autonomia:
  - **Nível 1** – Observador/Sugeridor:
    - lê, analisa, sugere ações; não executa nada externo sozinho.
  - **Nível 2** – Executor interno:
    - pode alterar arquivos locais, atualizar Notion, organizar informações,
    - mas não publica nada para o mundo sem aprovação.
  - **Nível 3** – Executor externo:
    - pode enviar e-mails, postar em redes, interagir com APIs externas de maneira que represente Adriano.
    - exige fluxo de aprovação explícito.

- Estado atual recomendado:
  - Publicação externa (email, LinkedIn, Buffer) em **Nível 1/2**:
    - agentes rascunham; Adriano aprova e publica.

---

## 5. Incidentes e rotinas

**Objetivo:** ter um plano claro quando algo quebra ou quando há vazamento.

### 5.1. Quando a integração quebra (Gmail, Calendar, Notion, etc.)

Fluxo combinado:

1. Adriano sinaliza em linguagem natural (ex.: "Gmail quebrou", "Calendar não responde", "Notion parou").
2. Pola executa uma escada de recuperação equivalente a `~/openclaw-recover.sh`:
   - `openclaw status`
   - `openclaw gateway status`
   - `openclaw gateway restart`
   - `openclaw doctor`
   - `openclaw channels status --probe`
   - testes específicos da integração (ex.: `gog gmail labels list`, `gog calendar list`).
3. Pola retorna:
   - diagnóstico (onde está o problema),
   - próximos passos (refazer OAuth, ajustar config, etc.).

### 5.2. Quando há vazamento de segredo

Modelo de resposta a incidente:

1. **Conter**
   - Identificar quais segredos foram expostos (onde e quando).
   - Listar: Telegram, Buffer, Notion, Tavily, gateway, outros tokens do `.env` que tenham vazado.

2. **Erradicar**
   - Rotacionar/revogar todos esses segredos na origem (portais dos serviços).
   - Atualizar `.env` e `openclaw.json` com as novas chaves.
   - Garantir que tokens antigos não estão mais em uso.

3. **Recuperar / Validar**
   - Executar:
     - `openclaw doctor`
     - `openclaw status`
     - `openclaw channels status --probe`
   - Testar manualmente as integrações impactadas (Gmail, Calendar, Notion, Buffer, etc.).

4. **Melhorar**
   - Ajustar hábitos que levaram ao vazamento (ex.: evitar colar tokens em chat, revisar comandos de log).
   - Se necessário, limpar logs locais específicos que contenham tokens em texto claro.

---

## 6. Rotina operacional recomendada

Para o dia a dia, adotar os seguintes comandos como "check básico":

```bash
openclaw status
openclaw doctor
openclaw channels status --probe
```

E usar os scripts:

- `~/openclaw-healthcheck.sh` – monitoramento contínuo (cron a cada 5 minutos).
- `~/openclaw-recover.sh` – recuperação rápida quando algo aparenta estar quebrado.

Quando algo estiver estranho, o fluxo é:

1. Rodar `~/openclaw-recover.sh` **ou** pedir para Pola "consertar a integração".
2. Se persistir, analisar `openclaw logs --follow` e aplicar o checklist de segurança/atualização.

---

Este modelo deve ser revisado periodicamente à medida que:
- novos agentes forem criados,
- mais integrações forem adicionadas,
- o nível de autonomia dos agentes aumentar.

Ponto-chave: segurança e estabilidade primeiro; autonomia e velocidade vêm em cima de uma base sólida.