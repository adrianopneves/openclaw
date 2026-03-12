# MEMORY-WRITE-RULES.md — Quando e Como Gravar

Resumo da MEMORY-POLICY v3.0 (seção escrita):

1. Toda decisão relevante, mudança em agente/fluxo, problema importante, aprendizado significativo ou criação/edição de arquivo de sistema → registrar em `memory/logs/YYYY-MM-DD.md`.
2. Promover para `memory/semantic/` ou `memory/procedural/` quando:
   - será relevante por > 2 semanas;
   - impacta comportamento futuro;
   - evita retrabalho;
   - muda a forma padrão de operar.
3. Nunca gravar como memória estável:
   - contexto temporário da sessão;
   - explorações descartadas;
   - informações que mudam em dias;
   - instruções one-shot sem recorrência.
4. Cada entrada de log deve conter: o que mudou + por quê + quando, com status draft/confirmed.
5. Gravar no momento da decisão, não apenas ao final da sessão.
