# Session: 2026-03-07 14:39:34 UTC

- **Session Key**: agent:main:main
- **Session ID**: f6f7b8ac-2862-4201-8ca7-8f3933f11f5d
- **Source**: webchat

## Conversation Summary

user: Sender (untrusted metadata):
```json
{
  "label": "openclaw-control-ui",
  "id": "openclaw-control-ui"
}
```

[Sat 2026-03-07 11:29 GMT-3] Use tavily to search: inteligência artificial 2025
assistant: Tavily search isn’t configured yet on this machine (missing `TAVILY_API_KEY`), so I can’t actually run that search command.

To enable it, you (on the host) would need to:

1. Sign up / log in at: https://tavily.com  
2. Create an API key.
3. On your Mac (where OpenClaw is running), set the environment variable, for example in your shell config (`~/.zshrc` or similar):

   ```bash
   export TAVILY_API_KEY="your_real_key_here"
   ```

4. Restart the OpenClaw gateway/agent so it inherits the new env:

   ```bash
   openclaw gateway restart
   ```

After that, the control UI instruction “Use tavily to search: inteligência artificial 2025” will work and I’ll be able to run:

```bash
node skills/tavily-search/scripts/search.mjs "inteligência artificial 2025" -n 5 --topic news --days 365
```

If you’d like, I can instead run a normal web search (via the built‑in `web_search` tool) for “inteligência artificial 2025” right now and summarize what I find.
user: Sender (untrusted metadata):
```json
{
  "label": "openclaw-control-ui",
  "id": "openclaw-control-ui"
}
```

[Sat 2026-03-07 11:39 GMT-3] Use tavily to search: inteligência artificial 2025
assistant: Não consigo usar Tavily nem o `web_search` por enquanto, porque faltam as chaves de API no ambiente onde o OpenClaw está rodando.

Aqui o que precisa ser feito no host para isso funcionar:

1. **Configurar Tavily (para o skill `tavily-search`)**
   - Crie uma conta e um API key em: https://tavily.com  
   - No shell onde o OpenClaw é iniciado, defina a variável:
     ```bash
     export TAVILY_API_KEY="SUA_CHAVE_TAVILY_AQUI"
     ```
   - Reinicie o gateway:
     ```bash
     openclaw gateway restart
     ```

2. **(Opcional) Configurar Brave Search para o `web_search`**
   - Obtenha um BRAVE_API_KEY (veja doc do OpenClaw):
     ```bash
     openclaw configure --section web
     ```
     ou exporte:
     ```bash
     export BRAVE_API_KEY="SUA_CHAVE_BRAVE_AQUI"
     ```
   - E reinicie o gateway, se necessário.

Depois disso, quando o control UI mandar “Use tavily to search: inteligência artificial 2025”, vou conseguir de fato rodar a busca Tavily e retornar os resultados.
