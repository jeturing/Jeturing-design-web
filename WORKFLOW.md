# argo-web — Workflow Pencil → Approve → Build

> Cualquier stack · React · Svelte · Vue · Vanilla JS · cualquier framework

---

## El Flujo Obligatorio

```
IDEA ──▶ 01-PENCIL ──▶ 02-APPROVAL ──▶ 03-BUILD
              ↑               ↑
         Diseñar en        Firmar antes
         Pencil primero    de escribir código
```

**⛔ Regla #0: Sin 02-approval.md firmado, NO se empieza el desarrollo.**

---

## Paso a Paso

### 1. Crear estructura de la pantalla

```bash
bash design-system/scripts/new-screen.sh "login" "Pantalla de inicio de sesión"
```

El script interactivo preguntará:
- **Paleta** (1-10) — 10 paletas curadas listas para usar
- **Stack** (Svelte / React / Vue / Vanilla / Otro)

Genera en `design/screens/<slug>/`:
```
01-pencil.pen       ← Template Pencil listo para abrir
02-approval.md      ← Lista de chequeo + tokens CSS de la paleta
03-flow-ascii.md    ← Flujo elemento a elemento
04-components.md    ← Selección de componentes MCP magic
05-db-model.md      ← Modelo de datos / API endpoints
06-motion-plan.md   ← Plan de animaciones con motion v12
```

### 2. Diseñar en Pencil

- Abrir `01-pencil.pen` en **Pencil** (app de wireframing)
- Aplicar los tokens CSS de la paleta elegida
- Diseñar mobile (375px) y desktop (1280px)
- Documentar cada elemento con su animación planeada

### 3. ⛔ Aprobar antes de codear

Completar y **firmar** `02-approval.md`:
- Paleta aplicada con variables CSS (nunca hardcoded)
- Responsive verificado
- Motion plan completo
- Componentes seleccionados
- Contraste WCAG AA ≥ 4.5:1

### 4. Elegir componentes (MCP magic)

En `04-components.md`, antes de implementar:
1. Usar MCP magic para buscar 3 variantes de cada componente
2. Presentar opciones al equipo
3. Documentar la selección

### 5. Implementar 1:1 con el diseño

- Seguir el diseño aprobado al píxel
- Implementar animaciones del `06-motion-plan.md`
- Usar **siempre** variables CSS (`var(--color-primary)`, nunca `#003B73`)

### 6. Animar con Motion v12

```typescript
import { animate, stagger, inView } from 'motion'

// Framework-agnostic: React useEffect, Svelte onMount, Vue onMounted
animate('.hero', { opacity: [0, 1], y: [20, 0] }, { duration: 0.5 })
animate('.card', { opacity: [0, 1], y: [16, 0] }, { delay: stagger(0.07) })
inView('.section', ({ target }) => {
  animate(target, { opacity: [0, 1], y: [24, 0] }, { duration: 0.6 })
})
```

---

## Las 10 Paletas Curadas

```
01 Dark Tech          #003B73 + #00FF9F  SaaS, Tech Premium          [dark]
02 Oxford Legal       #1B3A6B + #E8C96B  Corporativo, Legal          [light]
03 Navy Power         #1B2E3C + #4B0000  Lujo, Alta Gama             [dark]
04 Dark Luxury        #201315 + #E76D57  Elegante, Premium            [dark]
05 Warm Gold          #532200 + #E1A140  Moderno, Lujoso              [dark]
06 Warm Glam          #28221E + #7F6951  Real Estate Premium         [light]
07 Forest Gold        #122620 + #D6AD60  Luxury, Naturaleza           [dark]
08 Marsala Classic    #663635 + #DEB3AD  Clásico, Minimalista        [light]
09 Deep Blue Premium  #091235 + #88A9C3  Tech, Profundo               [dark]
10 Trust Warm         #532200 + #E1A140  Confianza, Calidez          [light]
```

Ver catálogo completo: [`palettes/index.md`](palettes/index.md)

---

## Anti-patrones (prohibidos)

| ❌ Nunca | ✅ Siempre |
|---------|-----------|
| Colores hardcoded `#003B73` | Variables CSS `var(--color-primary)` |
| Empezar a codear sin wireframe | Wireframe aprobado primero |
| Spinner genérico de loading | Skeleton loader personalizado |
| `setTimeout` para animaciones | `motion` v12 |
| Emojis como íconos | SVG siempre |
| Ignorar `prefers-reduced-motion` | Verificar siempre |
| Colores AI-genéricos (azul/verde tipo Bootstrap) | Una de las 10 paletas curadas |

---

## Recursos

- **Paletas:** [`palettes/`](palettes/) — 10 CSS files listos
- **Motion utils:** [`skill/motion.ts`](skill/motion.ts)
- **Tailwind tokens:** [`skill/tailwind.config.ts`](skill/tailwind.config.ts)
- **Pencil template:** [`skill/pencil-new.pen`](skill/pencil-new.pen)
