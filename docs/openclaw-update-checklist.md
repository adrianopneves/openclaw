# Checklist de Update Seguro do OpenClaw (Mac mini)

## 0. Preparar

- [ ] Abrir Terminal no Mac mini
- [ ] Confirmar que nenhum comando crítico está em execução

## 1. Backup de configuração

```bash
mkdir -p ~/.openclaw/backups
cp ~/.openclaw/openclaw.json ~/.openclaw/backups/openclaw.json.pre-update-$(date +%Y%m%d-%H%M)
```

## 2. Atualizar pelo instalador oficial

```bash
curl -fsSL https://openclaw.ai/install.sh | bash -- --no-onboard
```

## 3. Verificações pós-update

```bash
openclaw status
openclaw gateway status
openclaw doctor
openclaw channels status --probe
```

## 4. Testes de Gmail / Calendar (gog)

```bash
GOG_ACCOUNT=pola.agentic@gmail.com gog --no-input auth status
GOG_ACCOUNT=pola.agentic@gmail.com gog gmail labels list --max 5
GOG_ACCOUNT=pola.agentic@gmail.com gog calendar list
```

Se todos passarem → ambiente saudável.

## 5. Telegram / sessão nova

- [ ] No Telegram, rodar `/new` para iniciar sessão nova
- [ ] Fazer um teste simples: "meus últimos emails" ou "meus próximos eventos"
