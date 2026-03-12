# linkedin-analytics · SPEC

Objetivo: disponibilizar dados estruturados de performance dos posts do LinkedIn do Adriano para o agente Vox/Pola.

## Escopo

- Ler periodicamente a performance dos posts do perfil linkedin.com/in/adrianopicchineves
- Extrair, no mínimo, para cada post:
  - id ou url
  - data/hora de publicação
  - texto (ou primeiro trecho)
  - tipo (texto, imagem, carrossel, vídeo)
  - métricas: reactions, comentários, reposts, impressões (se disponível)
- Salvar em arquivo estruturado em `data/linkedin/posts.json` (ou .csv) para análise e refinamento de estratégia.

## I/O

Entrada:
- Credenciais ou método de acesso ao LinkedIn (API oficial ou export manual de dados).

Saída:
- Arquivo: `data/linkedin/posts.json`

Formato sugerido:
```json
[
  {
    "id": "<string>",
    "url": "<string>",
    "published_at": "YYYY-MM-DDTHH:MM:SSZ",
    "type": "text|image|carousel|video",
    "text_preview": "<primeiras 300–500 chars>",
    "metrics": {
      "reactions": <int>,
      "comments": <int>,
      "reposts": <int>,
      "impressions": <int|null>
    }
  }
]
```

## Integração com Vox/Pola

- Vox/Pola lê `data/linkedin/posts.json` para:
  - identificar posts com melhor performance,
  - extrair padrões (tema, tamanho, formato, dia da semana),
  - alimentar `memory/semantic/LINKEDIN-STRATEGY.md` com insights.

## Implementação sugerida

- Fase 1 (manual):
  - Exportar dados de posts do LinkedIn (quando disponível) e escrever um script que converta para o formato acima.
- Fase 2 (automatizada):
  - Integrar via API ou automação segura para atualizar o arquivo em base recorrente (cron).

## Pendências para implementação real

- Definir método de acesso aos dados do LinkedIn (API/app ou export manual).
- Criar script real (provavelmente via agente de coding) para preencher `posts.json`.
