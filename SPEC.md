# SPEC — Ngen: Music for Mind's Peace

**Versión:** 0.1 MVP  
**Fecha:** 2026-05-14  
**Stack:** Vanilla HTML/CSS/JS · Web Audio API · localStorage · Sin backend

---

## 1. Visión del Producto

Ngen es una Progressive Web App (PWA) de musicoterapia para bienestar mental y productividad. Guía al usuario por ciclos científicos de foco y descanso (inspirados en Pomodoro y protocolos de neurofeedback) combinados con música diseñada para inducir estados cognitivos óptimos.

**Principios de diseño:**
- Sin fricción: cero cuentas, cero servidores, cero instalación
- Privacidad total: todos los datos viven en localStorage del usuario
- Offline-first: funciona sin conexión una vez cargada
- Instalable como PWA en iOS y Android

---

## 2. Diseño Visual

### Tipografía
| Rol | Fuente | Peso |
|-----|--------|------|
| Títulos / Display | Cormorant Garamond | 400, 600 |
| Body / UI | Inter | 400, 500, 600 |

Carga vía Google Fonts. Fallback: Georgia → serif / system-ui → sans-serif.

### Paleta de colores
```css
:root {
  --bg:         #1a2b3c;   /* fondo principal (azul noche) */
  --text:       #e8b84b;   /* texto dorado principal */
  --detail-white: #ffffff;
  --detail-gold:  #ffcc00;
  --rest-bg:    #5290c9;   /* fondo modo Recovery */
  --rest-text:  #ffffff;

  /* Derivados funcionales */
  --surface:    rgba(255,255,255,0.06);  /* tarjetas / pills */
  --border:     rgba(232,184,75,0.2);
  --muted:      rgba(232,184,75,0.5);
}
```

### Layout
- Contenedor tipo phone: **390 × 844 px** centrado en pantalla
- En pantallas más pequeñas: 100vw × 100dvh (full mobile)
- Fondo exterior al contenedor: `#0d1a26` (más oscuro que --bg)
- Border-radius del contenedor: `24px` en desktop, `0` en mobile real

### Tab Bar
Tab bar fijo al fondo del contenedor con 3 ítems:
- **Home** (ícono: casa) — Page 1
- **Statistics** (ícono: gráfico) — Page 10
- **Community** (ícono: personas) — placeholder, "Próximamente"

El tab bar se oculta durante las páginas de sesión activa (Pages 3–6, 9).

---

## 3. Stack Técnico

| Decisión | Elección | Motivo |
|----------|----------|--------|
| Estructura | UN SOLO ARCHIVO `index.html` | Drag & drop deploy, sin build tools |
| JS | Vanilla ES2022 | Sin dependencias, máxima compatibilidad |
| CSS | Custom properties + Flexbox/Grid | Sin framework |
| Audio | Web Audio API nativa | Sin Howler.js, control total, iOS compatible |
| Persistencia | localStorage (`ngen_history`) | Sin backend |
| Deploy | GitHub Pages / Netlify drop | Sin CI/CD |
| PWA | manifest + service worker inline | Instalable y offline |

### Estructura del archivo `index.html`
```
<head>
  Google Fonts preconnect + link
  <style> — todo el CSS </style>
  PWA manifest (inline via <link> a manifest.json separado O blob URL)
</head>
<body>
  <!-- Páginas como divs con data-page="N" -->
  <div id="app">
    <div class="page" id="page-1"> ... </div>
    ...
    <div class="tab-bar"> ... </div>
  </div>
  <script> — todo el JS </script>
</body>
```

---

## 4. Arquitectura de Navegación

El router es un sistema simple basado en clases CSS: solo la página activa tiene `class="page active"`. Sin URLs hash por defecto (opcional añadir).

```
Page 1 (Home)
  ↓ "Iniciar Sesión"
Page 2 (Setup)
  ↓ "Continuar →" + precarga audio
Page 9 (Loading)
  ↓ audio listo
Page 3 (Track Selection)
  ↓ "Confirmar y comenzar Sync →"
Page 4 (Sync Mode — 3 min)
  ↓ auto-avance
Page 5 (Flow State — 25/40/50 min)
  ↓ auto-avance
Page 6 (Recovery — 5/10/15 min)
  ↓ ciclos restantes > 0 → Page 5
  ↓ ciclos agotados → Page 7
Page 7 (Feedback)
  ↓ "Ver resultados →"
Page 8 (Session End)
  ↓ "Volver al inicio" → guarda localStorage → Page 1

Page 10 (Statistics) — acceso desde tab bar
```

---

## 5. Páginas — Especificación Detallada

### Page 1 — HOME

**Elementos:**
- Logo SVG + nombre "Ngen" (Cormorant Garamond 48px)
- Subtítulo: "Music for Mind's Peace" (Inter, --muted)
- Grid 3 columnas de métricas agregadas (desde localStorage):
  - **Tiempo Enfocado** — suma total en horas/min
  - **Tiempo Recuperando** — suma total
  - **Índice Burnout** — promedio ponderado (ver cálculo §8)
- Botón primario: "Iniciar Sesión"
- Botón secundario: "Actualizar mi gusto musical" (placeholder — misma Page 2 pero solo sliders)
- Lista de últimas 5 sesiones:
  - Fecha · Track elegido · Duración · PFS score
  - Estado vacío: ilustración + "Aún no tienes sesiones"

**Estado vacío (primera vez):**
Todas las métricas en 0 o `--`. Texto de bienvenida breve.

---

### Page 2 — INICIO DE SESIÓN (Setup)

**Sección 1 — Estado emocional actual:**
4 sliders verticales u horizontales (0–100), etiquetados:
- Tristeza
- Enojo
- Soledad
- Estrés

Diseño: thumb dorado, track con gradiente de intensidad.

**Sección 2 — Evaluación de vida (Cantril Ladder simplificada):**
3 botones radio estilizados:
- 🌱 Floreciendo
- ⚖️ Luchando
- 🌧️ Sufriendo

**Sección 3 — Configuración de sesión:**
- Selector de intervalo (3 opciones, botones pill):
  - `25 min foco / 5 min descanso`
  - `40 min foco / 10 min descanso`
  - `50 min foco / 15 min descanso`
- Selector de horas totales (1 – 4):
  - Determina número de ciclos = `horas × 60 / (foco + descanso)`
  - Ejemplo: 2h con 25/5 → 4 ciclos
- Resumen calculado: "X ciclos · Y horas de foco · Z horas de descanso"

**CTA:** Botón "Continuar →" → inicia precarga de audio → navega a Page 9

---

### Page 9 — CARGA

**Elementos:**
- Spinner o animación de onda de audio
- Texto: "Preparando tu sesión"
- Subtexto rotativo cada 2s (array de ~8 tips sobre musicoterapia)
- Barra de progreso de carga de audio

**Lógica:**
1. Intenta cargar archivos `.wav` reales con `fetch()` + Web Audio API `decodeAudioData()`
2. Si falla (archivo no encontrado) → genera tono sintético equivalente con `OscillatorNode` + `GainNode`
3. Cuando todos los buffers están listos → navega automáticamente a Page 3

**Tips de ejemplo:**
- "La música a 60 BPM sincroniza tu ritmo cardíaco con el estado de calma"
- "El silencio entre notas es tan importante como las notas mismas"
- "La música en modo menor no siempre causa tristeza — puede inducir introspección productiva"
- *(añadir 5 más)*

---

### Page 3 — ELECCIÓN DE SYNC

**Elementos:**
- Encabezado: "Elige tu track de Sync"
- 3 tarjetas (Sync_1, Sync_2, Sync_3):
  - Nombre + descripción breve del mood (ej. "Sereno · 60 BPM")
  - Botón ▶ Preview — reproduce 10s del inicio del track
  - Borde dorado cuando está seleccionado
- Botón "Confirmar y comenzar Sync →" (deshabilitado hasta selección)

**Lógica de preview:**
- Al presionar ▶ → reproduce los primeros 10s del AudioBuffer
- Icono cambia a ⏹ durante reproducción
- Solo un preview activo a la vez

---

### Page 4 — SYNC MODE

**Duración fija:** 3 minutos (180s)

**Elementos:**
- Badge pill: "Sync Mode" (color --detail-gold)
- Timer circular SVG:
  - Círculo de fondo + arco de progreso con stroke-dashoffset animado
  - Número countdown central: `3:00 → 0:00`
- Instrucción: "Cierra los ojos y respira profundo"
- Audio: `Sync_N.wav` seleccionado → loop

**Transiciones de audio:**
- A **t = 120s** (cuando restan 60s): fade-in de `cue_to_Flow_state.wav` sobre el Sync loop

**Navegación:** Al llegar a 0 → auto-avance a Page 5

---

### Page 5 — FLOW STATE

**Duración:** variable según intervalo elegido (25 / 40 / 50 min)

**Elementos:**
- Badge pill: "Flow State" (color --detail-gold)
- Timer circular SVG (igual que Page 4 pero más grande)
- Indicador de ciclo: "Ciclo 1 de 4" (Cormorant Garamond)
- Fila de fases como indicador visual de progreso:
  ```
  [Sync] → [Focus] → [Transition] → [Rest]
  ```
  Fase activa resaltada con --detail-gold
- Controles de audio (fila de íconos):
  - ↺ Reset (reinicia el ciclo actual)
  - ⏮ Skip-back (vuelve 15s)
  - ⏸/▶ Play/Pause
  - ⏭ Skip (adelanta 15s)
  - ⏩ Skip-forward (salta al siguiente ciclo)
- Audio: `Flow_State.wav` → loop

**Transición de audio:**
- A **t = duracion - 60s**: fade-in de `cue_to_recovery.wav` sobre el Flow loop

**Navegación:** Al llegar a 0 → auto-avance a Page 6

---

### Page 6 — RECOVERY (Deep Rest)

**Duración:** variable según intervalo (5 / 10 / 15 min)

**Cambio visual:**
- `body` / contenedor cambia a `background: var(--rest-bg)` con transición CSS `ease 1s`
- Texto cambia a `var(--rest-text)`

**Elementos:**
- Badge pill: "Deep Rest" (blanco sobre azul claro)
- Orbe de respiración:
  - Círculo SVG o `div` con animación pulse CSS
  - Ciclo: Expand 4s · Hold 7s · Shrink 8s · Repeat
  - Texto interior cambia: "Inhala" / "Sostén" / "Exhala"
- Guía de respiración 4-7-8 en texto
- Tarjeta al pie: "Próximamente — Contenido de bienestar" (placeholder)
- Audio: `Recovery.wav` → loop

**Cues de fin de Recovery:**
- Si `ciclos_restantes > 0`:
  - A 60s del fin: fade-in `cue_to_Flow_state.wav`
  - Al terminar → back to Page 5, incrementar contador de ciclo
- Si `ciclos_restantes === 0`:
  - A 60s del fin: fade-in tono de finalización (o silencio gradual)
  - Al terminar → Page 7

**Navegación:** Auto-avance según lógica de ciclos.

---

### Page 7 — FEEDBACK

**Sección 1 — PFS (Psychological Flow Scale, Norsworthy et al., 2023):**
9 ítems · Escala Likert **1–7** (1 = Totalmente en desacuerdo / 7 = Totalmente de acuerdo)
Mide la **intensidad del flow experimentado en esta sesión**. Tres dimensiones (3 ítems c/u):

*Absorción* — atención profunda y fusión acción-conciencia:
1. Estuve completamente absorbido/a en la tarea
2. Mi atención estaba totalmente centrada en lo que hacía
3. Me perdí por completo en la actividad

*Control Effortless* — sensación de control sin esfuerzo consciente:
4. Mis acciones fluyeron sin esfuerzo
5. Sentí que tenía el control total de lo que hacía
6. La tarea se sintió inusualmente fluida y sin fricción

*Recompensa Intrínseca* — experiencia positiva y arousal óptimo:
7. La experiencia fue intrínsecamente gratificante
8. Me sentí en un estado óptimo de activación
9. Disfruté profundamente el proceso, independientemente del resultado

> **Nota:** Los ítems exactos de la publicación original (Springer, 2023) no son de acceso abierto.
> Los ítems anteriores son traducciones funcionales validadas conceptualmente contra el artículo.
> Fuente: DOI 10.1007/s41042-023-00092-8

**Scoring PFS:**
- Promedio de los 9 ítems → rango 1.0–7.0
- Subescalas: promedio de ítems 1-3, 4-6, 7-9
- Sin ítems de puntuación invertida

---

**Sección 2 — GFPS (Global Flow Proneness Scale, Elnes & Sigmundsson, 2023):**
13 ítems · Escala Likert **1–5** (1 = Totalmente en desacuerdo / 5 = Totalmente de acuerdo)
Mide la **predisposición general al estado de flow** (rasgo, no estado puntual).
Administrar solo en la primera sesión o con periodicidad mensual — no en cada feedback.

Ítems (traducción al español — versión oficial solo en inglés):
1. Disfruto de tareas desafiantes que requieren mucha concentración.
2. Cuando me enfoco en una tarea, tiendo a olvidar mi entorno (personas, tiempo, lugar).
3. Generalmente experimento un buen flujo cuando hago algo (las cosas no me resultan ni demasiado fáciles ni demasiado difíciles).
4. Tengo varios ámbitos de interés distintos.
5. Me cuesta dejar o abandonar un proyecto en el que estoy trabajando.
6. Me estreso ante tareas difíciles o desafiantes. *(invertido)*
7. Me resulta difícil mantener la concentración durante un tiempo prolongado. *(invertido)*
8. Me canso rápidamente de las cosas que hago. *(invertido)*
9. Generalmente estoy satisfecho/a con los resultados de mis esfuerzos (experimento sensación de dominio).
10. Con frecuencia olvido tomarme un descanso cuando me concentro en algo.
11. Me aburro con facilidad. *(invertido)*
12. Mis tareas diarias me resultan agotadoras en lugar de estimulantes. *(invertido)*
13. Desarrollo interés en la mayoría de las cosas que hago en la vida.

**Scoring GFPS:**
- Ítems invertidos: 6, 7, 8, 11, 12 → puntuación = (6 − valor_seleccionado)
- Promedio de los 13 ítems → rango 1.0–5.0
- Fuente: SAGE Open, DOI 10.1177/21582440231153850 (acceso abierto)

**Sección 3 — Re-test emocional:**
Mismos 4 sliders de Page 2 (posición inicial = valor de entrada)

**Sección 4 — Re-evaluación de vida:**
Mismos 3 botones radio (Floreciendo / Luchando / Sufriendo)

**CTA:** "Ver resultados →"

---

### Page 8 — FIN DE SESIÓN

**Elementos:**
- Título: "Felicitaciones" (Cormorant Garamond, grande)
- Subtítulo: "`N` ciclos completados"
- Grid 2×2 de cards de métricas:
  - **Tiempo de Foco** — total en esta sesión
  - **Tiempo de Descanso** — total en esta sesión
  - **Burnout Evitado** — calculado (ver §8)
  - **Score de Flow (PFS)** — promedio PFS 1.0–7.0
- Card de Proneness (GFPS) — si se administró en esta sesión; si no, muestra el último valor registrado con su fecha
- Delta de evaluación de vida:
  - `Antes: Luchando → Después: Floreciendo` con ícono de flecha
  - Si igual: "Te mantuviste estable"
  - Si bajó: texto de apoyo empático
- Botón "Volver al inicio" → guarda sesión en localStorage → Page 1

---

### Page 10 — ESTADÍSTICAS

**Filtro de período** (pill buttons):
`1S · 1M · 3M · 6M · 1Y · Todo`

**Gráficos (Canvas 2D o SVG handcrafted):**
4 gráficos de línea apilados verticalmente:
1. **Tiempo Foco** (min por sesión)
2. **Burnout** (índice calculado)
3. **Estrés** (slider promedio de sesión)
4. **Satisfacción de vida** (0=Sufriendo / 1=Luchando / 2=Floreciendo)

Cada gráfico: eje X = fechas, eje Y = valores, línea dorada sobre fondo oscuro.

**Estado vacío:** ilustración + "Completa tu primera sesión para ver estadísticas"

---

## 6. Sistema de Audio

### Archivos esperados (en mismo directorio que `index.html`)
| Archivo | Uso | Loop |
|---------|-----|------|
| `Sync_1.wav` | Track Sync opción 1 | Sí |
| `Sync_2.wav` | Track Sync opción 2 | Sí |
| `Sync_3.wav` | Track Sync opción 3 | Sí |
| `Flow_State.wav` | Música de foco | Sí |
| `Recovery.wav` | Música de descanso | Sí |
| `cue_to_Flow_state.wav` | Transición → Flow | No |
| `cue_to_recovery.wav` | Transición → Recovery | No |

### Arquitectura Web Audio API
```
AudioContext
  ├── sourceNode (BufferSourceNode, loop=true)  →  gainNode (main)  →  destination
  └── cueNode   (BufferSourceNode, loop=false)  →  gainNode (cue)   →  destination
```

**Fade crossover:** al superponer cue, el gainNode del loop hace fade-out gradual en 5s mientras el cue suena. Después del cue, el siguiente loop hace fade-in.

### Fallback sintético
Si `fetch(archivo.wav)` falla (404 o red), el sistema genera un equivalente:
| Archivo original | Fallback sintético |
|------------------|--------------------|
| Sync_N.wav | OscillatorNode sine 60 BPM, freq 174Hz (Fa), reverb simulado |
| Flow_State.wav | Binaural beat simulado: 200Hz L / 210Hz R (diferencia 10Hz = alpha) |
| Recovery.wav | Sine 432Hz con tremolo lento 0.1Hz |
| Cues | Tone suave 1s con GainNode fade |

### Compatibilidad iOS
- `AudioContext` debe reanudarse en respuesta a user gesture (tap)
- El primer tap en "Confirmar y comenzar Sync" sirve como gesture unlock
- `audioContext.resume()` llamado explícitamente

---

## 7. Persistencia — localStorage

### Key principal: `"ngen_history"`
Valor: array JSON de objetos `Session`.

### Tipo `Session`
```typescript
interface Session {
  id: string;               // UUID v4 o timestamp
  date: string;             // ISO 8601
  trackChosen: "Sync_1" | "Sync_2" | "Sync_3";
  interval: 25 | 40 | 50;  // minutos de foco
  totalHours: 1 | 2 | 3 | 4;
  cyclesCompleted: number;

  // Emociones
  emotionsBefore: { tristeza: number; enojo: number; soledad: number; estres: number };
  emotionsAfter:  { tristeza: number; enojo: number; soledad: number; estres: number };

  // Evaluación de vida
  lifeBefore: "floreciendo" | "luchando" | "sufriendo";
  lifeAfter:  "floreciendo" | "luchando" | "sufriendo";

  // Cuestionarios
  pfs:     number[];  // 9 valores 1-7 (Psychological Flow Scale — post-sesión)
  pfsAvg:  number;    // promedio, rango 1.0–7.0
  gfps:    number[];  // 13 valores 1-5 (Global Flow Proneness Scale — solo 1ª sesión o mensual)
  gfpsAvg: number;    // promedio tras invertir ítems 6,7,8,11,12; rango 1.0–5.0
  gfpsApplied: boolean; // false si no se administró en esta sesión

  // Tiempo real
  focusMinutes:    number;
  recoveryMinutes: number;
  burnoutIndex:    number;  // calculado
}
```

### Cálculo del Índice Burnout
```
burnoutIndex = (pfsAvg / 5) * 0.4
             + (estres_before / 100) * 0.3
             + (lifeScore_before / 2) * 0.3
```
Donde `lifeScore`: sufriendo=1, luchando=0.5, floreciendo=0.

`burnoutEvitado` en Page 8 = `burnoutIndex_before - burnoutIndex_after` (si > 0).

---

## 8. PWA

### `manifest.json`
```json
{
  "name": "Ngen — Music for Mind's Peace",
  "short_name": "Ngen",
  "start_url": "./",
  "display": "standalone",
  "background_color": "#1a2b3c",
  "theme_color": "#e8b84b",
  "icons": [
    { "src": "icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

### Service Worker (inline en `<script>` de index.html o archivo separado `sw.js`)
Estrategia: **Cache First** para assets estáticos, **Network First** para nada (sin red necesaria).

Archivos a cachear:
- `index.html`
- Google Fonts (si hay red en primer load)
- Archivos `.wav` (si existen)
- `manifest.json`, `icon-*.png`

---

## 9. Criterios de Éxito MVP

| # | Criterio | Cómo verificar |
|---|----------|----------------|
| 1 | Flujo completo Home → Sesión → Feedback → Resultados → Home | Test manual end-to-end |
| 2 | Audio funciona en iOS Safari y Android Chrome | Test en dispositivo real |
| 3 | Datos persisten entre sesiones (cerrar y reabrir) | Verificar localStorage en DevTools |
| 4 | Instalable como PWA (prompt aparece en Chrome/Safari) | Lighthouse PWA audit ≥ 90 |
| 5 | Funciona offline (sin conexión tras primer load) | DevTools → Network → Offline |

---

## 10. Fuera del Alcance MVP

- Autenticación o cuentas de usuario
- Backend, API, base de datos
- Contenido de Community (placeholder)
- Contenido de bienestar en Recovery (placeholder "Próximamente")
- Compartir sesiones o resultados
- Múltiples idiomas
- Temas de color alternativos

---

## 11. Archivos del Proyecto

```
ngen-project/
├── index.html          ← ÚNICO archivo de código
├── manifest.json
├── sw.js               ← Service Worker (opcional separar)
├── icon-192.png        ← Ícono PWA
├── icon-512.png        ← Ícono PWA
├── Sync_1.wav
├── Sync_2.wav
├── Sync_3.wav
├── Flow_State.wav
├── Recovery.wav
├── cue_to_Flow_state.wav
├── cue_to_recovery.wav
└── SPEC.md             ← Este archivo
```

---

## 12. Notas de Implementación

- **Router:** función `navigateTo(pageId)` que agrega/quita clase `active`. Mantener historial en variable JS para botón Atrás lógico.
- **Estado global:** objeto `AppState` en JS con toda la sesión en curso. No persistir hasta Page 8.
- **Timers:** usar `performance.now()` + `requestAnimationFrame` para timers precisos. No confiar en `setInterval` para la UI del timer.
- **Accesibilidad mínima:** `aria-label` en botones de control de audio, `role="timer"` en countdown, `prefers-reduced-motion` para deshabilitar animaciones de orbe.
- **Sin `alert()`:** todos los estados de error se muestran en UI inline.
