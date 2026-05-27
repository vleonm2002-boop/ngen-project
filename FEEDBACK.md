# Feedback — Ngen

El agente revisa este archivo cada 10 minutos.  
Agrega una línea con `- [ ] ` para solicitar un cambio. El agente la implementará y la marcará como `- [x]`.

---

## Pendiente

- [x] Agregar skip button en pantalla de la sesión (Focus) para ir a la próxima pantalla del loop.

- [x] Agregar encuesta Psychological Flow Scale al final de cada sesión (cuando el loop se rompe). Escala Likert de 7 puntos: 1 = completamente en desacuerdo, 7 = completamente de acuerdo.

  **Subescalas e ítems:**
  - Absorción (ítems 1–3):
    1. "Estuve absorto(a) en la tarea"
    2. "Estaba muy enfocado(a) en la tarea"
    3. "Toda mi atención estaba en la tarea"
  - Effortless Control (ítems 4–6):
    4. "Sentí que podía controlar fácilmente lo que hacía"
    5. "Mis acciones fluían sin esfuerzo"
    6. "Había una sensación de fluidez en mis acciones"
  - Intrinsic Reward (ítems 7–9):
    7. "La experiencia me pareció gratificante"
    8. "La experiencia se sintió satisfactoria"
    9. "Me gustaría volver a tener esa experiencia"

  **UI:** Mostrar solo las preguntas, no los números de ítem ni la subescala.

  **Botón omitir:** La pantalla de encuesta incluye un botón "Omitir". Al pulsarlo, mostrar un pop-up de confirmación con el mensaje:
  > "Si saltas esta opción no podremos evaluar tu progreso, ni podremos personalizar tu experiencia para tu beneficio. ¿Deseas omitir de todas formas?"

  Opciones del pop-up: **Omitir** | **Responder**
  - Si elige *Omitir*: se guarda el registro de la sesión con todos los scores como nulo (null).
  - Si elige *Responder*: cierra el pop-up y vuelve a la encuesta.

- [ ] Calcular y guardar los resultados de la encuesta al completarla:
  - Promediar ítems 1, 2 y 3 → Puntuación de Absorción
  - Promediar ítems 4, 5 y 6 → Puntuación de Effortless Control
  - Promediar ítems 7, 8 y 9 → Puntuación de Intrinsic Reward
  - Promediar los 9 ítems → Global Flow Score

- [ ] Crear nueva tabla en la base de datos para almacenar los resultados por sesión. Si no existe base de datos crear una:

  | Columna | Tipo de dato |
  |---|---|
  | user_id | UUID / FK → tabla de usuarios |
  | session_number | INTEGER |
  | date | TIMESTAMP |
  | global_flow_score | FLOAT, nullable |
  | absorption_score | FLOAT, nullable |
  | effortless_control_score | FLOAT, nullable |
  | intrinsic_reward_score | FLOAT, nullable |

- [ ] Agregar a la pantalla de estadísticas (Stats) existente — sin reemplazar lo que ya aparece — las siguientes métricas de flow, con selector de rango de tiempo (semana / mes / trimestre / semestre / año / total desde creación de cuenta):
  - Global Flow Score
  - Puntuación de Absorción
  - Puntuación de Control sin Esfuerzo
  - Puntuación de Recompensa Intrínseca
  - Incluir un gráfico de progreso para el rango seleccionado, mostrando la evolución de cada puntuación a lo largo del tiempo (promedio por sesión dentro del rango). Los valores null (sesiones omitidas) no se incluyen en el cálculo del promedio.
<!-- Escribe aquí. Un ítem por línea, con "- [ ] " al inicio (espacio después de los corchetes). -->
<!-- Ejemplo: - [ ] En la pantalla Home, cambiar el texto del botón a "Iniciar sesión de foco" -->

## Implementado

- [x] Ícono de música en Homepage con color de fuente (`--text`)
- [x] Ícono musical en "Aún no tienes sesiones" con color de fuente
- [x] Colores azules (`--bg`, `--rest-bg`) reemplazados por verde tierra oscuro
- [x] Cambiar color `--bg` a `#396125`
- [x] Agregar skip button en pantallas de la sesión (Sync y Recovery)
