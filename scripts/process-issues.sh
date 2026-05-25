#!/bin/bash
# Procesa feedback de FEEDBACK.md usando Claude Code CLI

CLAUDE="/Users/victorleon/.local/node_modules/@anthropic-ai/claude-code-darwin-arm64/claude"
PROJECT="/Users/victorleon/Proyectos VSCode/ngen-project"
FEEDBACK_FILE="$PROJECT/FEEDBACK.md"
LOG="$PROJECT/scripts/process-issues.log"
# shellcheck source=../.ngen-secrets
source "$PROJECT/.ngen-secrets"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"; }

log "Revisando FEEDBACK.md..."

cd "$PROJECT" || exit 1

# Pull para obtener cambios de Benjamin
git pull --quiet origin main >> "$LOG" 2>&1

# Buscar primer ítem pendiente (- [ ] ...)
ITEM=$(grep -m1 '^\- \[ \]' "$FEEDBACK_FILE" 2>/dev/null | sed 's/^- \[ \] //')

if [ -z "$ITEM" ]; then
  log "Sin ítems pendientes."
  exit 0
fi

log "Procesando: $ITEM"

"$CLAUDE" --dangerously-skip-permissions -p "
Eres un agente que implementa cambios en la app Ngen (index.html, single-file PWA vanilla).

Solicitud de cambio: \"$ITEM\"

Pasos exactos:
1. Lee index.html y comprende qué hay que cambiar.
2. Implementa SOLO el cambio mínimo solicitado. No toques nada más.
3. En FEEDBACK.md, reemplaza la línea '- [ ] $ITEM' por '- [x] $ITEM'.
4. Haz: git add index.html FEEDBACK.md
5. Haz commit con mensaje: feedback: $(echo "$ITEM" | cut -c1-60)
6. Haz: git push origin main
" >> "$LOG" 2>&1

log "Ítem procesado: $ITEM"
