# FEEDBACK.md — Ngen Product Owner

> Este archivo es leído automáticamente por el agente cada 10 minutos.
> Agrega ítems en la sección PENDIENTE. El agente los moverá a EN PROCESO y luego a COMPLETADO.
> **Reglas:** Un ítem por bloque. Sé específico. Incluye pantalla y comportamiento esperado.

---

## 🔴 PENDIENTE

<!-- Copia este bloque para cada nuevo feedback -->

### [TIPO] Título corto del problema
- **Pantalla:** Nombre de la pantalla (ej: Home, Session, Recovery)
- **Descripción:** Qué está mal o qué falta
- **Comportamiento esperado:** Cómo debería funcionar
- **Prioridad:** Alta / Media / Baja
- **Captura:** (opcional) nombre del archivo de imagen si adjuntas una

---

## 🟡 EN PROCESO

<!-- El agente mueve ítems aquí cuando comienza a trabajarlos -->

---

## ✅ COMPLETADO

<!-- El agente mueve ítems aquí cuando termina, con fecha y descripción del cambio -->

---

## 📋 TIPOS DE ÍTEM

Usa estos prefijos en el título:
- `[BUG]` — Algo que no funciona
- `[UX]` — Mejora de experiencia de usuario
- `[FEATURE]` — Funcionalidad nueva
- `[COPY]` — Cambio de texto
- `[DESIGN]` — Cambio visual

---

## 📝 EJEMPLO COMPLETO

### [BUG] El timer no se detiene al pausar en Flow State
- **Pantalla:** Page 5 — Flow State
- **Descripción:** Al presionar pause el audio se detiene pero el timer sigue corriendo
- **Comportamiento esperado:** Al pausar, tanto el audio como el timer deben detenerse simultáneamente
- **Prioridad:** Alta
- **Captura:** bug_timer.png

### [UX] El orbe de respiración es muy pequeño en iPhone SE
- **Pantalla:** Page 6 — Recovery
- **Descripción:** El orbe se ve muy chico en pantallas de 375px de ancho
- **Comportamiento esperado:** El orbe debe ocupar al menos 60% del ancho de pantalla
- **Prioridad:** Media

### [COPY] Cambiar texto del botón de inicio
- **Pantalla:** Page 1 — Home
- **Descripción:** El botón dice "Start a Session" en inglés
- **Comportamiento esperado:** Debe decir "Iniciar sesión de foco"
- **Prioridad:** Baja
