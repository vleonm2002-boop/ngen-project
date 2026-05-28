# Feedback — Ngen

El agente revisa este archivo cada 10 minutos.  
Agrega una línea con `- [ ] ` para solicitar un cambio. El agente lo implementará y lo moverá a Implementado.

---

## Pendiente
- [ ] La página de la encuesta no debe tener scroll down, se debe dividir en Cuatro paginas, las primeras tres deben tener tres preguntas cada una y la cuarta página debe ser la pregunta ¿Cómo te sientes ahora? y ¿Cómo evalúas tu vida ahora?
- [ ] Una vez respondida la pregunta se Calcula y guarda scores de la encuesta (Absorción, Control sin Esfuerzo, Recompensa Intrínseca, Global Flow Score)
- [ ] Los calculos de (Absorción, Control sin Esfuerzo, Recompensa Intrínseca, Global Flow Score) deben ser agregados a las métricas de la página stats
- [ ] Cambiar el color de fondo de la aplicación de #396125 a #1f3015.
  - Buscar todas las ocurrencias de #396125 en el proyecto y reemplazarlas por #1f3015.
  - Verificar que el cambio se aplicó correctamente en todos los archivos afectados (estilos globales, temas, variables, etc.).
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
- [x] Cambiar color `--bg` a `#1f3015`
- [x] you didn´t change elements in the color #396125 to the color #1f3015
- [x] La página sync no debe ser parte del loop, solo debe aparecer al inicio de cada sesión
- [x] Antes de ir a la página de la la encuesta Psychological Flow Scale, debe mostrarse una página que pregunte si desea reportar su experiencia en la sesión para mejoras en la próxima. Un botón de omitir y otro de responder. Omitir te lleva a la página de inicio, responder a la página de la encuesta.
