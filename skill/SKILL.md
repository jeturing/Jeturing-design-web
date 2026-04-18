# Design-Web Skill — argo-web

> Skill para agentes AI: se activa para **cualquier trabajo de frontend/UI web**.
> Stack-agnostic: React · Svelte 5 · Vue 3 · Vanilla JS · cualquier framework.

---

## ⚠️ REGLA #0 — Pencil First (NO NEGOCIABLE)

**Antes de escribir UNA SOLA línea de código:**

1. `bash design-system/scripts/new-screen.sh "<slug>" "<descripcion>"` — crear estructura
2. El script preguntará **paleta** (1-10) y **stack**
3. Diseñar `01-pencil.pen` en Pencil (wireframe completo)
4. Firmar `02-approval.md` (aprobación explícita)
5. Solo entonces: implementar 1:1 con el diseño

```
IDEA → PENCIL → APPROVAL → BUILD
                    ↑
            ⛔ Sin firma = No código
```

---

## §1 — Stack y Contexto

Al iniciar cualquier pantalla, confirmar:
- **Stack:** React / Svelte 5 / Vue 3 / Vanilla JS / Otro
- **Paleta elegida:** Número 1-10 (preguntar si no está definida)
- **Estado del `02-approval.md`:** ¿firmado?

---

## §2 — Design Thinking

Antes de proponer cualquier UI, hacer 3 preguntas:
1. **¿Quién usa esto?** — Edad, contexto, dispositivo, nivel técnico
2. **¿Cuál es la única acción que importa?** — Jerarquía visual
3. **¿Qué emociones debe generar?** — Confianza, urgencia, calma, premium

---

## §3 — Color — Las 10 Paletas Curadas

**Regla:** Nunca inventar colores. Siempre una de las 10 paletas. Si el proyecto ya tiene brand, adaptar.

```
01 Dark Tech          #003B73 + #00FF9F  bg #0a0f1e   [dark]
02 Oxford Legal       #1B3A6B + #E8C96B  bg #F5F6FA   [light]
03 Navy Power         #1B2E3C + #4B0000  bg #0C0C1E   [dark]
04 Dark Luxury        #201315 + #E76D57  bg #201315   [dark]
05 Warm Gold          #532200 + #E1A140  bg #3A1500   [dark]
06 Warm Glam          #28221E + #7F6951  bg #CECBC8   [light]
07 Forest Gold        #122620 + #D6AD60  bg #0E1E1A   [dark]
08 Marsala Classic    #663635 + #DEB3AD  bg #F9F1F0   [light]
09 Deep Blue Premium  #091235 + #88A9C3  bg #091235   [dark]
10 Trust Warm         #532200 + #E1A140  bg #FDF6EC   [light]
```

**Tokens CSS** (siempre variables, nunca hardcoded):
```css
:root {
  --color-primary: [elegida];
  --color-accent:  [elegida];
  --bg-base:       [elegida];
  --bg-surface:    [elegida];
  --text-primary:  [elegida];
}

/* USO CORRECTO */
.card    { background: var(--bg-surface); border-left: 3px solid var(--color-primary); }
.btn-cta { background: var(--color-accent); color: var(--bg-base); }
.metric  { color: var(--color-accent); font-weight: 700; }
```

---

## §4 — Tipografía

```
Heading display:  Sora / Outfit / Plus Jakarta Sans  — bold 700
Heading section:  Sora / Outfit  — semibold 600
Body:             Inter / DM Sans  — regular 400
Mono / code:      JetBrains Mono  — regular 400
```

**Escala:** 12 · 14 · 16 · 18 · 24 · 32 · 48 · 64 · 80px

---

## §5 — Motion — Librería `motion` v12

```typescript
import { animate, stagger, inView } from 'motion'
// Framework-agnostic: React useEffect, Svelte onMount, Vue onMounted, Vanilla JS
```

### Patrones base

```typescript
// Fade in + slide up (entrada de página)
animate('.hero', { opacity: [0, 1], y: [20, 0] }, { duration: 0.5, easing: [0.16, 1, 0.3, 1] })

// Stagger (listas, cards, items)
animate('.card', { opacity: [0, 1], y: [16, 0] },
  { delay: stagger(0.07), duration: 0.5, easing: [0.16, 1, 0.3, 1] })

// Scroll reveal
inView('.section', ({ target }) => {
  animate(target, { opacity: [0, 1], y: [24, 0] }, { duration: 0.6 })
}, { margin: '-10% 0px' })

// Hover magnético
element.addEventListener('mousemove', (e) => {
  const r = element.getBoundingClientRect()
  const x = (e.clientX - r.left - r.width / 2) * 0.3
  const y = (e.clientY - r.top - r.height / 2) * 0.3
  animate(element, { x, y }, { duration: 0.2 })
})

// Error shake
animate(field, { x: [0, -8, 8, -8, 8, 0] }, { duration: 0.5 })

// prefers-reduced-motion — siempre verificar
if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
```

### Timing estándar

| Tipo | Duración | Easing |
|------|----------|--------|
| Micro (hover) | 150-200ms | easeOut |
| Entrada elemento | 400-500ms | easeOutExpo `[0.16,1,0.3,1]` |
| Página completa | 500-700ms | easeOutExpo |
| Scroll reveal | 600ms | easeOutExpo |

---

## §6 — Componentes — Flujo MCP Magic

**Antes de implementar cualquier componente:**
1. Buscar variantes con MCP magic (`@21st-dev/magic@latest`)
2. Presentar 3 opciones al usuario con preview visual
3. Documentar la selección en `04-components.md`
4. Implementar la opción elegida

**Estados obligatorios en cada componente:**
- `loading` → Skeleton (nunca spinner genérico)
- `empty` → Ilustración SVG + mensaje contextual + CTA
- `error` → Mensaje claro + acción de recuperación
- `success` → Estado final con datos reales

---

## §7 — Layout y Espaciado

**Grid:** 12 columnas en desktop, 4 en mobile
**Container max-width:** 1280px con padding 16px (mobile) / 32px (tablet) / 64px (desktop)
**Spacing scale:** 4 · 8 · 12 · 16 · 24 · 32 · 48 · 64 · 96 · 128px

```css
/* Base layout */
.container { max-width: 1280px; margin: 0 auto; padding: 0 clamp(1rem, 5vw, 4rem); }
.grid-main { display: grid; grid-template-columns: repeat(12, 1fr); gap: 1.5rem; }
```

---

## §8 — Calidad y Accesibilidad

- Contraste WCAG AA mínimo: 4.5:1 texto, 3:1 UI interactiva
- Íconos: SVG siempre — nunca emoji como íconos funcionales
- Imágenes: `alt` descriptivo siempre
- Focus visible: `outline: 2px solid var(--color-accent); outline-offset: 2px`
- Touch targets: mínimo 44×44px en mobile
- Skeleton loaders: siempre sobre spinner genérico

---

## §9 — Workflow Completo

```
1. bash new-screen.sh "slug" "descripcion"   ← genera 6 archivos
2. Paleta elegida (1-10) + Stack confirmado
3. Diseñar en 01-pencil.pen (Pencil)
4. Completar 03-flow-ascii.md
5. Buscar componentes con MCP magic → 04-components.md
6. Definir DB/API → 05-db-model.md
7. Planear animaciones → 06-motion-plan.md
8. ⛔ FIRMAR 02-approval.md
9. Implementar 1:1 con el diseño
10. Animar con motion v12
```

---

## §10 — MCP Magic

```
API Key: 1b51a593be0dd33cb18bd6c4784c0d3b3807e9de12bb898c957dde7afddca506
Config:  ~/.config/mcp/magic.json  |  mcp_config.json
```

Usar para: búsqueda de componentes UI, inspiración visual, variantes de diseño.
**Siempre presentar opciones, no decidir unilateralmente.**

---

## §11 — Anti-patrones (prohibidos)

| ❌ Nunca | ✅ Siempre |
|---------|-----------|
| `color: #003B73` hardcoded | `color: var(--color-primary)` |
| Empezar código sin wireframe aprobado | Pencil → Approval → Build |
| `setTimeout(fn, 300)` para animaciones | `motion` animate/inView |
| Spinner `.animate-spin` genérico | Skeleton loader de contenido |
| Emojis como íconos funcionales | SVG siempre |
| Ignorar `prefers-reduced-motion` | Verificar con `matchMedia` |
| Inventar paleta nueva | Una de las 10 paletas curadas |
| Azul Bootstrap / verde Material | Paletas con carácter y personalidad |

---

## §12 — Recursos del Repo

```
https://github.com/jeturing/Jeturing-design-web  (argo-web)

palettes/         10 paletas CSS listas
skill/motion.ts   Utilities de animación framework-agnostic
skill/pencil-new.pen  Template Pencil completo
scripts/new-screen.sh  Scaffolding interactivo
```
