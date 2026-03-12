TITLE: OpenClaw Environment Overview

EXEC_SUMMARY: OpenClaw é um framework de automação local que orquestra habilidades (skills) e pontes (bridges) para integrar ferramentas como Claude CLI em pipelines estruturados, com um gateway central gerenciando a execução.

KEY_FINDINGS:
- Estrutura baseada em `~/.openclaw/` com `workspace/bridges/`, `skills/`, e um `gateway`
- O Claude Bridge atua como conector entre prompts de entrada e o CLI `claude --print`, salvando runs com timestamp em `runs/`
- Skills são módulos executáveis (`bin/run`) com detecção automática de modo (linkedin, notion, web, etc.)
- Saída sempre formatada em campos estruturados: TITLE, EXEC_SUMMARY, KEY_FINDINGS, NEXT_STEPS, FULL_ANALYSIS

NEXT_STEPS:
- Verificar se `openclaw gateway restart` foi bem-sucedido
- Testar a skill via pipeline: `echo "tarefa" | ~/.openclaw/skills/claude-bridge/bin/run`
- Adicionar novos modos no detector de MODE conforme necessário

FULL_ANALYSIS:
O OpenClaw é seu ambiente pessoal de orquestração de IA local. Ele funciona como um sistema de skills modulares conectadas a um gateway central. O Claude Bridge instalado pelo script cria uma integração onde qualquer prompt enviado ao bridge é:

1. Salvo em um diretório de run com timestamp (`runs/YYYYMMDD-HHMMSS/`)
2. Executado via `claude --print` (Claude CLI local)
3. Retornado em formato estruturado e padronizado

O ambiente permite expandir com novas bridges (ex: Notion, web) seguindo o mesmo padrão, mantendo histórico de todas as execuções e um symlink `latest` para a mais recente.
