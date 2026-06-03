# Feedback — Ngen

El agente revisa este archivo cada 10 minutos.  
Agrega una línea con `- [ ] ` para solicitar un cambio. El agente lo implementará y lo moverá a Implementado.

---

## Pendiente
<!-- Un ítem por línea, con "- [ ] " al inicio. Ejemplo: -->
<!-- - [ ] En la pantalla Home, cambiar el texto del botón a "Iniciar sesión de foco" -->
- [ ] Página 8 (Stat Report): botones de rango — Este mes, 3 meses, 6 meses, 1 año, Total
- [ ] Página 8 (Stat Report): por cada rango mostrar promedios de tiempo en flow, tiempo en break, Global Flow Score, Absorption Score, Effortless Control Score, Intrinsic Reward Score, ansiedad, estrés, tristeza y cansancio — leídos desde resultados_sesiones filtrado por user_id y rango de fecha
- [ ] Página 8 (Stat Report): gráfico de línea mostrando evolución temporal de los valores en el rango seleccionado
- [ ] Página 10 (Registro): opción de registro con Google OAuth y con correo + contraseña, flujo con CAPTCHA, aceptación de términos y condiciones, al confirmar crear registro en tabla usuarios y navegar a Página 1
- [ ] Base de datos — crear tabla usuarios con campos: id (UUID PK), nombre, apellido, email (único), ubicacion, genero, tipo_sesion (enum: gratuita/pago), created_at (timestamp)
- [ ] Base de datos — crear tabla resultados_sesiones con campos: id (UUID PK), user_id (FK → usuarios), global_flow_score, absorption_score, effortless_control_score, intrinsic_reward_score, stress_start_score, anxiety_start_score, saddness_start_score, tiredness_start_score, global_mh_start_score, stress_end_score, anxiety_end_score, saddness_end_score, tiredness_end_score, global_mh_end_score, global_mh_day_score, tiempo_flow_min, tiempo_break_min, date (timestamp)
- [ ] Autenticación: implementar login con correo + Google OAuth, persistir sesión localmente, exponer función isLoggedIn() usada por la barra de navegación y flujos condicionales de Página 1
- [ ] Audio: detener todo audio activo al navegar fuera de la sesión (Página 5 en adelante). Manejar archivo no encontrado con error silencioso sin crashear la app
- [ ] Pop-ups de "Próximamente" deben tener animación fade out al desaparecer automáticamente
- [ ] El cronómetro debe seguir corriendo si la app va a background (implementar background timer)
## Implementado

- [x] Ícono de música en Homepage con color de fuente (`--text`)
- [x] Ícono musical en "Aún no tienes sesiones" con color de fuente
- [x] Colores azules (`--bg`, `--rest-bg`) reemplazados por verde tierra oscuro
- [x] Cambiar color `--bg` a `#396125`
- [x] Agregar skip button en pantallas de la sesión (Sync y Recovery)
- [x] Agregar skip button en pantalla de la sesión (Focus) para ir a la próxima pantalla del loop
- [x] Agregar encuesta Psychological Flow Scale (9 ítems, Likert 1–7) al final de cada sesión con botón Omitir y pop-up de confirmación
- [x] Calcular y guardar scores de la encuesta (Absorción, Control sin Esfuerzo, Recompensa Intrínseca, Global Flow Score)
- [x] Crear almacenamiento de resultados por sesión (ngen_flow_results en localStorage con user_id UUID)
- [x] Agregar métricas de flow en pantalla de estadísticas con gráficos por rango de tiempo
- [x] Cambiar color `--bg` a `#1f3015`
- [x] you didn´t change elements in the color #396125 to the color #1f3015
- [x] La página sync no debe ser parte del loop, solo debe aparecer al inicio de cada sesión
- [x] Antes de ir a la página de la la encuesta Psychological Flow Scale, debe mostrarse una página que pregunte si desea reportar su experiencia en la sesión para mejoras en la próxima. Un botón de omitir y otro de responder. Omitir te lleva a la página de inicio, responder a la página de la encuesta.
- [x] La página de la encuesta no debe tener scroll down, se debe dividir en Cuatro paginas, las primeras tres deben tener tres preguntas cada una y la cuarta página debe ser la pregunta ¿Cómo te sientes ahora? y ¿Cómo evalúas tu vida ahora?
- [x] Una vez respondida la pregunta se Calcula y guarda scores de la encuesta (Absorción, Control sin Esfuerzo, Recompensa Intrínseca, Global Flow Score)
- [x] Los calculos de (Absorción, Control sin Esfuerzo, Recompensa Intrínseca, Global Flow Score) deben ser agregados a las métricas de la página stats
- [x] Cambiar el color de fondo de la aplicación de #396125 a #1f3015.
- [x] La barra de navegación inferior debe tener 4 botones: Home, Stats, Comunidad, Sesión
- [x] Si la sesión está iniciada: Home → Página 1, Stats → Página 8, Comunidad → pop-up "Próximamente" por 3 segundos
- [x] Si la sesión no está iniciada: cualquier botón de la barra → navegar a Página 9 (Login)
- [x] La barra de navegación inferior debe ocultarse completamente durante una sesión activa (Páginas 3, 4, 5, 6) y reaparecer al llegar a Página 7 o Página 1
- [x] Página 1 (Home): mostrar stats de la semana en la parte superior — tiempo en flow state y tiempo descansando — leídos desde base de datos filtrando por semana actual
- [x] Página 1 (Home): botón "Iniciar sesión de trabajo" → navega a Página 2
- [x] Página 1 (Home): botón "Personalizar música" → pop-up "Próximamente". Si el usuario no tiene sesión iniciada, después del pop-up mostrar segundo pop-up: "¿Deseas iniciar sesión para notificarme de actualizaciones y guardar tu progreso?" con botones Sí (→ Página 9) y No (→ cerrar pop-up, quedarse en Página 1)
- [x] Página 2 (Settings): selector de duración total de sesión con opciones 1h, 2h, 3h, 4h, 6h, 8h
- [x] Página 2 (Settings): selector de ciclo con opciones 25min/5min, 40min/10min, 50min/10min
- [x] Página 2 (Settings): calcular y mostrar cantidad_ciclos = floor(duración_total / (flow + break)) y guardar en variable de estado local
- [x] Página 2 (Settings): reporte de bienestar inicial — 4 sliders Likert 1–7 para estrés, ansiedad, tristeza y cansancio. Guardar como Stress_start_Score, Anxiety_start_Score, Saddness_start_Score, Tiredness_start_Score
- [x] Página 3 (Flow State): cronómetro regresivo con duración de flow seleccionada
- [x] Página 3 (Flow State): reproducir Flow_state.wav en loop durante todo el flow state. Si el archivo es más corto que el tiempo, repetirlo en loop
- [x] Página 3 (Flow State): cuando quede 1 minuto reproducir Cue_break.wav una sola vez
- [x] Página 3 (Flow State): botón "Skip a descanso" → navegar a Página 4 inmediatamente
- [x] Página 4 (Micro Break): cronómetro regresivo con duración de break seleccionada
- [x] Página 4 (Micro Break): reproducir Micro_break.wav en loop durante todo el break. Si el archivo es más corto que el tiempo, repetirlo en loop
- [x] Página 4 (Micro Break): si cantidad_ciclos > 0, restar 1 a cantidad_ciclos, cuando quede 1 minuto reproducir Cue_flow.wav una sola vez, al terminar el cronómetro → Página 3
- [x] Página 9 (Login): campos de correo electrónico y contraseña, botón "Iniciar sesión", link "¿No tienes cuenta? Regístrate" → Página 10
- [x] Página 4 (Micro Break): si cantidad_ciclos === 0, al terminar el cronómetro → Página 5
- [x] Página 4 (Micro Break): botón skip con label dinámico — "Skip a Flow state" si quedan ciclos, "Finalizar sesión" si no quedan
- [x] Página 5 (¿Responder encuesta?): pantalla con texto "¿Desea responder una encuesta sobre su experiencia en la sesión para mejorar su experiencia?" con botones Sí (→ Página 6) y No (→ Página 7)
- [x] Página 6 (Encuesta PFS): mostrar las siguientes 9 preguntas de forma secuencial, una a la vez, escala Likert 1–7 (1 = completamente en desacuerdo, 7 = completamente de acuerdo). Al responder cada pregunta desaparece y aparece la siguiente. Las preguntas son — (1) "Estuve absorto(a) en la tarea", (2) "Estaba muy enfocado(a) en la tarea", (3) "Toda mi atención estaba en la tarea", (4) "Sentí que podía controlar fácilmente lo que hacía", (5) "Mis acciones fluían sin esfuerzo", (6) "Había una sensación de fluidez en mis acciones", (7) "La experiencia me pareció gratificante", (8) "La experiencia se sintió satisfactoria", (9) "Me gustaría volver a tener esa experiencia"
- [x] Página 6 (Encuesta PFS): calcular Absorption_Score = avg(ítems 1, 2, 3), Effortless_Control_Score = avg(ítems 4, 5, 6), Intrinsic_Reward_Score = avg(ítems 7, 8, 9), Global_Flow_Score = avg(ítems 1–9). Al terminar → Página 7
- [x] Página 7 (Stats de sesión): mostrar tiempo en flow, tiempo en break y Global Flow Score (solo si se respondió la encuesta)
- [x] Página 7 (Stats de sesión): reporte de bienestar de salida — 4 sliders Likert 1–7 para estrés, ansiedad, tristeza y cansancio. Guardar como Stress_end_Score, Anxiety_end_Score, Saddness_end_Score, Tiredness_end_Score
- [x] Página 7 (Stats de sesión): calcular y guardar en tabla resultados_sesiones — Global_mental_health_start_score = avg(stress/anxiety/saddness/tiredness start), Global_mental_health_end_score = avg(stress/anxiety/saddness/tiredness end), Global_mental_health_day_score = avg(start, end), y deltas absolutos por dimensión = abs(x_start - x_end)
- [x] Página 7 (Stats de sesión): botón "Volver a Home" → Página 1
