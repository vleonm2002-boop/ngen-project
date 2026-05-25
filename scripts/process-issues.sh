#!/bin/bash
# Procesa issues de GitHub con label "feedback" usando Claude Code CLI

CLAUDE="/Users/victorleon/.local/node_modules/@anthropic-ai/claude-code-darwin-arm64/claude"
PROJECT="/Users/victorleon/Proyectos VSCode/ngen-project"
# shellcheck source=../.ngen-secrets
source "$PROJECT/.ngen-secrets"
LOG="$PROJECT/scripts/process-issues.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"; }

log "Revisando issues..."

ISSUES=$(curl -s \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO/issues?labels=feedback&state=open&per_page=1")

COUNT=$(echo "$ISSUES" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d) if isinstance(d,list) else 0)" 2>/dev/null)

if [ "$COUNT" = "0" ] || [ -z "$COUNT" ]; then
  log "Sin issues pendientes."
  exit 0
fi

NUM=$(echo "$ISSUES" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['number'])")
TITLE=$(echo "$ISSUES" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['title'])")
BODY=$(echo "$ISSUES" | python3 -c "import sys,json; d=json.load(sys.stdin)[0]; print(d.get('body','') or '(sin descripción)')")

log "Procesando issue #$NUM: $TITLE"

cd "$PROJECT" || exit 1

"$CLAUDE" --dangerously-skip-permissions -p "
Eres un agente que implementa cambios en la app Ngen (index.html, single-file PWA vanilla).

Issue #$NUM: \"$TITLE\"
Descripción: $BODY

Pasos exactos a seguir:
1. Lee el archivo index.html y comprende el cambio solicitado.
2. Implementa SOLO el cambio mínimo necesario. No refactorices nada más.
3. Haz git add index.html y git commit con mensaje: feedback(#$NUM): descripcion breve en español
4. Haz git push origin main
5. Llama a la API de GitHub para comentar en el issue #$NUM:
   curl -s -X POST -H 'Authorization: token $TOKEN' -H 'Accept: application/vnd.github.v3+json' https://api.github.com/repos/$REPO/issues/$NUM/comments -d '{\"body\":\"✅ Implementado y desplegado en https://ngen-project.vercel.app\"}'
6. Cierra el issue:
   curl -s -X PATCH -H 'Authorization: token $TOKEN' -H 'Accept: application/vnd.github.v3+json' https://api.github.com/repos/$REPO/issues/$NUM -d '{\"state\":\"closed\"}'
" >> "$LOG" 2>&1

log "Issue #$NUM procesado."
