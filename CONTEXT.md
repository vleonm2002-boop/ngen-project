# Ngen — Contexto técnico para el agente

App de bienestar mental. Single-file PWA: **todo el código está en `index.html`** (HTML + CSS + JS).  
Sin backend. Sin frameworks. Sin build tools. Persistencia en `localStorage` únicamente.

---

## Páginas existentes (NO crear duplicados)

| ID | Nombre | Descripción |
|---|---|---|
| page-1 | Home | Dashboard principal. Métricas, sesiones recientes. |
| page-2 | Setup | Configuración de sesión: track, duración, ciclos. |
| page-9 | Track Selection | Selección de pista musical. |
| page-3 | Loading | Carga de audio. Barra de progreso. |
| page-4 | Sync Mode | Timer de sincronización (3 min). Botón "Saltar Sync →". |
| page-5 | Flow State | Timer de enfoque. Controles de audio. Botón "Saltar Focus →". |
| page-6 | Recovery | Timer de descanso. Orbe de respiración 4-7-8. Botón "Saltar descanso →". |
| page-12 | Pre-Survey | Pantalla "¿Deseas reportar tu experiencia?". Botones Responder/Omitir. |
| page-11 | PFS Step 1/3 | Encuesta PFS ítems 1–3. Escala Likert 1–7. |
| page-11b | PFS Step 2/3 | Encuesta PFS ítems 4–6. |
| page-11c | PFS Step 3/3 | Encuesta PFS ítems 7–9. Botón "Siguiente" llama submitFlowSurvey(). |
| page-7 | Feedback | Estado emocional post-sesión. GFPS condicional. |
| page-8 | Session End | Resumen de resultados de la sesión. |
| page-10 | Statistics | Métricas históricas + gráficos. Selector de rango de tiempo. |

## Flujo de navegación

```
page-2 → page-9 → page-3 → page-4 (Sync) → page-5 (Flow) → page-6 (Recovery)
  → [si quedan ciclos] → page-4
  → [último ciclo] → page-12 → page-11 → page-11b → page-11c → page-7 → page-8 → page-1
                  → [Omitir survey] → page-7 → page-8 → page-1
```

## Funciones JS clave (NO redefinir)

- `navigateTo(pageId)` — navega entre páginas
- `startSyncMode()` — inicia page-4
- `startFlowState()` — inicia page-5
- `startRecovery()` — inicia page-6
- `initFlowSurvey()` — renderiza PFS step 1 en page-11
- `goSurveyStep(n)` — avanza entre steps de PFS
- `submitFlowSurvey()` — guarda scores y va a page-7
- `skipFlowSurvey()` — muestra modal de confirmación
- `skipPreSurvey()` — omite PFS, va a page-7
- `initFeedback()` — inicializa page-7 (emociones + GFPS)
- `showResults()` — calcula resultados y va a page-8
- `finishSession()` — guarda sesión en Store y va a page-1
- `renderStats()` — renderiza page-10 con métricas
- `T.start/pause/resume/skip/stop` — control del timer

## Estado global (objeto S)

```js
S = {
  track, focusMin, restMin, totalCycles, currentCycle,
  totalHours, focusAccum, restAccum,
  emotBefore, emotAfter, lifeBefore, lifeAfter,
  pfsAns[9], pfsSkipped, _pfsResult,
  gfpsAns[13], gfpsApplied,
  statsDays
}
```

## Persistencia localStorage

- `Store` (key: `ngen_history`) — array de sesiones completas
- `FlowResults` (key: `ngen_flow_results`) — scores de PFS por sesión
- `ngen_user_id` — UUID persistente del usuario

## Reglas que NO se deben romper

1. Todo el código va en `index.html`. No crear archivos separados.
2. No usar fetch, APIs externas ni localStorage distinto a los existentes.
3. No redefinir funciones ya existentes — modificarlas en su lugar.
4. No agregar páginas con IDs ya existentes.
5. Verificar que el JS no tenga errores de sintaxis antes de hacer commit.
6. Solo hacer `git add index.html FEEDBACK.md` — no agregar otros archivos.
