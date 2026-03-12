# linkedin-fetch-posts · SPEC

Objetivo: capturar rapidamente os textos e datas dos últimos N posts do Adriano no LinkedIn, sem depender de API, usando browser/CLI.

## Escopo

- A partir da página de atividade de Adriano:
  - https://www.linkedin.com/in/adrianopicchineves/recent-activity/all/
- Ler os últimos N posts (ex.: 10–20):
  - data relativa (ex.: "1 week ago") ou absoluta
  - texto completo
  - tipo básico (texto, imagem, carrossel)
- Salvar em formato leve para consumo pelo Vox/Pola.

## Saída

Arquivo sugerido: `data/linkedin/recent_posts.json`

Formato:
```json
[
  {
    "url": "<string>",
    "published_at": "<string>",
    "type": "text|image|carousel",
    "text": "<conteúdo completo do post>"
  }
]
```

## Integração

- Vox/Pola usa `recent_posts.json` para:
  - analisar posts recentes;
  - alimentar `memory/semantic/LINKEDIN-STRATEGY.md` com exemplos reais;
  - gerar novos posts baseados em temas/formato que funcionaram.

## Implementação sugerida

- Usar o browser tool do OpenClaw ou um script CLI (Playwright/Puppeteer) para:
  - abrir a página de atividade,
  - rolar para carregar N posts,
  - extrair texto + data + urls,
  - escrever o JSON de saída.

## Pendências

- Implementação do script real (provavelmente via agente de coding).
- Definir periodicidade (manual, heartbeat ou cron).
