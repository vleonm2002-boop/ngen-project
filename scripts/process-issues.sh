#!/bin/bash
# Procesa feedback de FEEDBACK.md usando Claude Code CLI

CLAUDE="/Users/victorleon/.local/node_modules/@anthropic-ai/claude-code-darwin-arm64/claude"
PROJECT="/Users/victorleon/Proyectos VSCode/ngen-project"
FEEDBACK_FILE="$PROJECT/FEEDBACK.md"
CONTEXT_FILE="$PROJECT/CONTEXT.md"
LOG="$PROJECT/scripts/process-issues.log"
# shellcheck source=../.ngen-secrets
source "$PROJECT/.ngen-secrets"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"; }

log "Revisando cambios..."
cd "$PROJECT" || exit 1

# Guardar hash de design.md antes del pull
DESIGN_HASH_BEFORE=$(git rev-parse HEAD:design.md 2>/dev/null)

PULL_OUT=$(git pull origin main 2>&1)
log "git pull: $PULL_OUT"

# ── DESIGN TOKENS ─────────────────────────────────────────────
DESIGN_HASH_AFTER=$(git rev-parse HEAD:design.md 2>/dev/null)
if [ "$DESIGN_HASH_BEFORE" != "$DESIGN_HASH_AFTER" ]; then
  log "design.md cambió — aplicando tokens..."
  DESIGN_OUT=$(python3 "$PROJECT/scripts/apply-design.py" 2>&1)
  log "apply-design: $DESIGN_OUT"
fi
# ──────────────────────────────────────────────────────────────

# Buscar primer ítem pendiente (acepta "- [ ] texto" y "- [ ]texto")
RAW_LINE=$(grep -m1 '^\- \[ \]' "$FEEDBACK_FILE" 2>/dev/null)
ITEM=$(echo "$RAW_LINE" | sed 's/^- \[ \] *//')

if [ -z "$ITEM" ]; then
  log "Sin ítems pendientes."
  exit 0
fi

log "Procesando: $ITEM"

# Snapshot para rollback si algo falla
git stash --quiet

"$CLAUDE" --dangerously-skip-permissions -p "
Lee primero el archivo CONTEXT.md para entender la arquitectura completa antes de hacer cualquier cambio.

Solicitud de cambio: \"$ITEM\"

REGLAS OBLIGATORIAS:
- Nunca crear páginas con IDs que ya existen en CONTEXT.md.
- Nunca redefinir funciones JS que ya existen — modificarlas en su lugar.
- Todo el código va en index.html únicamente.
- Verificar que los cambios no rompan el flujo de navegación descrito en CONTEXT.md.

Pasos:
1. Lee CONTEXT.md para entender la arquitectura.
2. Lee index.html y comprende qué hay que cambiar.
3. Implementa SOLO el cambio solicitado. Nada más.
4. En FEEDBACK.md:
   a. Elimina la línea que contiene '- [ ]' seguido de '$ITEM'.
   b. Agrega '- [x] $ITEM' al final de la sección ## Implementado.
5. Haz: git add index.html FEEDBACK.md
6. Haz commit: feedback: $(echo "$ITEM" | cut -c1-60)
7. Haz: git push origin main
" >> "$LOG" 2>&1

# Validar sintaxis JS del index.html resultante
if grep -q "function\|const \|let \|var " "$PROJECT/index.html"; then
  # Extraer el bloque <script> y validar con node
  python3 -c "
import re, sys
html = open('$PROJECT/index.html').read()
scripts = re.findall(r'<script>(.*?)</script>', html, re.DOTALL)
combined = '\n'.join(scripts)
open('/tmp/ngen_validate.js', 'w').write(combined)
" 2>/dev/null
  if node --check /tmp/ngen_validate.js 2>> "$LOG"; then
    log "Validación JS: OK"
    git stash drop --quiet 2>/dev/null
  else
    log "ERROR: Sintaxis JS inválida — haciendo rollback"
    git checkout -- index.html
    git stash pop --quiet 2>/dev/null
  fi
fi

log "Ítem procesado: $ITEM"
