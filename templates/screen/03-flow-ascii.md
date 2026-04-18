# Flujo ASCII — [ Nombre de Pantalla ]

**Pantalla:** `[ screen-slug ]`  
**Fecha:** YYYY-MM-DD

---

## Flujo de Navegación y Elementos

Documentar elemento por elemento con su animación:

```
USER ARRIVES
     │
     ▼
┌───────────────────────────────┐
│  [ Elemento 1 ]              │  ← fadeIn (0.3s)
└───────────────────────────────┘
         │
         ▼
┌───────────────────────────────┐
│  [ Elemento 2 ] (×N)        │  ← stagger (0.07s each)
└───────────────────────────────┘
         │
         ▼
┌───────────────────────────────┐
│  [ Sección scroll ]         │  ← inView (margin: -10%)
└───────────────────────────────┘
```

---

## Estados de la Pantalla

```
ESTADO INICIAL
│
├─▶ LOADING → [ Skeleton loader — NO spinner genérico ]
├─▶ EMPTY   → [ Ilustración SVG + mensaje contextual + CTA ]
├─▶ ERROR   → [ Mensaje claro + acción de recuperación ]
└─▶ SUCCESS → [ Datos reales con animaciones ]
```

---

## Interacciones Clave

| Elemento | Acción del usuario | Resultado | Animación |
|----------|--------------------|-----------|------------|
| [ CTA btn ] | click | [ acción ] | scale 0.98 + ripple |
| [ Form ] | submit invalid | Error inline | shakeError |
| [ Card ] | hover | [ tooltip / expand ] | scale 1.02 |

---

## Flujos Alternativos

```
[ Completar con ramas de flujo: auth required, permisos, redirects... ]
```
