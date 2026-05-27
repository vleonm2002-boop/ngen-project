# Feedback — Ngen

El agente revisa este archivo cada 10 minutos.  
Agrega una línea con `- [ ] ` para solicitar un cambio. El agente lo implementará y lo moverá a Implementado.

---

## Pendiente

<!-- Un ítem por línea, con "- [ ] " al inicio. Ejemplo: -->
<!-- - [ ] En la pantalla Home, cambiar el texto del botón a "Iniciar sesión de foco" -->

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
