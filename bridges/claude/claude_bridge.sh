#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$HOME/.openclaw/workspace/bridges/claude"
RUN_ID="$(date '+%Y%m%d-%H%M%S')"
RUN_DIR="$BASE_DIR/runs/$RUN_ID"
LATEST_LINK="$BASE_DIR/runs/latest"

mkdir -p "$RUN_DIR"

PROMPT_INPUT="${1:-}"
MODE="${2:-generic}"

if [ -z "$PROMPT_INPUT" ]; then
  echo "Erro: prompt vazio" >&2
  exit 1
fi

REQUEST_FILE="$RUN_DIR/request.txt"
RESULT_FILE="$RUN_DIR/result.md"
LOG_FILE="$RUN_DIR/debug.log"

cat > "$REQUEST_FILE" <<EOT
MODE: $MODE

INSTRUCTION:
$PROMPT_INPUT

FORMATO DE SAIDA OBRIGATORIO:
TITLE:
EXEC_SUMMARY:
KEY_FINDINGS:
NEXT_STEPS:
FULL_ANALYSIS:
EOT

echo "[INFO] $(date '+%F %T') Iniciando execução Claude" >> "$LOG_FILE"

"$HOME/bin/run-claude.sh" "$REQUEST_FILE" "$RESULT_FILE" >> "$LOG_FILE" 2>&1

if [ ! -s "$RESULT_FILE" ]; then
  echo "Erro: Claude não gerou saída" | tee -a "$LOG_FILE" >&2
  exit 1
fi

rm -rf "$LATEST_LINK"
ln -s "$RUN_DIR" "$LATEST_LINK"

awk '
/\*\*TITLE:\*\*/ {p=1}
/\*\*FULL_ANALYSIS:\*\*/ {exit}
p
' "$RESULT_FILE"
