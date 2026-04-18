---
name: design-web
description: >
  Skill de diseño UI/UX avanzado para el stack Svelte 5 + Tailwind CSS + Motion.
  Actívala cuando el usuario pida: componentes visuales, landing pages, dashboards,
  animaciones, mejoras de UI, rediseño de páginas, o cuando se trabaje en el frontend
  de SAJET (src/). Genera código production-ready con identidad visual
  coherente usando la paleta de marca (#003B73, #00FF9F), design systems modernos
  y animaciones con Motion (motion/react equivalente en Svelte via JS Motion API).
license: MIT
stack:
  - Svelte 5 (runes)
  - SvelteKit
  - Tailwind CSS 3
  - Motion (motion package v12+)
  - Lucide Svelte
  - TypeScript
brand:
  primary: "#003B73"
  accent: "#00FF9F"
  dark: "#0a0f1e"
  surface: "#111827"
---

# Design-Web Skill — UI/UX Intelligence (argo-web)

Skill de diseño production-ready para cualquier proyecto web Jeturing. Combina design systems
modernos, animaciones fluidas con Motion, y los patrones Svelte 5 runes.

Repo público: **https://github.com/jeturing/Jeturing-design-web**

---

## ⚠️ REGLA #0 — Pencil-First Obligatorio

**Toda pantalla nueva DEBE seguir este flujo SIN EXCEPCIONES:**

```
📐 PENCIL  →  ✅ APPROVE  →  💻 BUILD
```

1. **Crear carpeta de pantalla** con el script:
   ```bash
   bash design-system/scripts/new-screen.sh "<slug>" "<descripcion>"
   # Crea: design/screens/<slug>/ con los 6 archivos de documentación
   ```

2. **Diseñar en Pencil** → completar `01-pencil.pen` con:
   - Tokens de color y tipografía
   - Opciones de componentes (MCP magic)
   - Motion plan
   - Wireframes Desktop (1280px) + Mobile (375px)

3. **Obtener aprobación** → firmar `02-approval.md`
   - **⛔ Sin firma: NO se escribe código**

4. **Documentar** antes o durante el desarrollo:
   - `03-flow-ascii.md` — Flujo elemento a elemento con ASCII
   - `04-components.md` — Componentes seleccionados con opciones presentadas
   - `05-db-model.md` — Modelo BDA/DB si la pantalla consume datos
   - `06-motion-plan.md` — Tabla de animaciones por elemento

5. **Desarrollar 1:1** con el diseño aprobado

6. **Verificar Launch Checklist** en el `.pen` antes del PR

### Estructura de carpetas resultante:
```
design/
└── screens/
    └── <screen-name>/
        ├── 01-pencil.pen         ← Diseño visual (Pencil)
        ├── 02-approval.md        ← FIRMA OBLIGATORIA
        ├── 03-flow-ascii.md      ← Flujo ASCII elemento a elemento
        ├── 04-components.md      ← Opciones presentadas + selección
        ├── 05-db-model.md        ← Modelo de datos (o N/A)
        └── 06-motion-plan.md     ← Plan de animaciones Motion
```

---

## 1. Stack y Contexto del Proyecto

**Proyecto:** SAJET — SaaS ERP multi-tenant  
**Frontend:** `Erp_core/frontend/` — SvelteKit + Svelte 5 + Tailwind CSS 3  
**Deploy:** Static SPA → `static/spa/` servido por nginx en PCT 202  
**Marca:** Primary `#003B73` (azul corporativo) + Accent `#00FF9F` (verde neón)

### Importaciones clave disponibles:
```typescript
// Animaciones — Motion JS API (no React, usar vanilla JS)
import { animate, scroll, inView, stagger } from "motion"

// Íconos — Lucide Svelte
import { TrendingUp, Users, Shield } from "lucide-svelte"

// i18n
import { t } from "svelte-i18n"
```

---

## 2. Design Thinking — Proceso Obligatorio

Antes de escribir código, razona en este orden:

1. **Propósito**: ¿Qué problema resuelve este componente? ¿Quién lo usa?
2. **Jerarquía visual**: ¿Qué elemento debe dominar? (data, CTA, estado, navegación)
3. **Estilo**: Elige UNO y ejecútalo con precisión:
   - **Glassmorphism dark** → para dashboards, paneles de datos
   - **Minimal dark SaaS** → para formularios, auth, settings
   - **Aurora UI** → para landing pages, marketing
   - **Brutalist accent** → para CTAs, onboarding, pricing
4. **Motion**: Define qué se anima y CUÁNDO (entrada, hover, scroll, estado)
5. **Diferenciador**: ¿Qué hace este componente MEMORABLE?

---

## 3. Paleta de Colores — SAJET Design System

```css
/* === VARIABLES CSS SAJET === */
:root {
  /* Brand */
  --color-primary: #003B73;
  --color-primary-light: #0055a8;
  --color-primary-dark: #002147;
  --color-accent: #00FF9F;
  --color-accent-dim: #00cc7a;

  /* Backgrounds (dark-first) */
  --bg-base: #0a0f1e;
  --bg-surface: #111827;
  --bg-elevated: #1a2235;
  --bg-glass: rgba(255, 255, 255, 0.05);

  /* Text */
  --text-primary: #f0f4ff;
  --text-secondary: #94a3b8;
  --text-muted: #475569;

  /* Semantic */
  --color-success: #22c55e;
  --color-warning: #f59e0b;
  --color-danger: #ef4444;
  --color-info: #38bdf8;

  /* Glass effect */
  --glass-border: rgba(0, 255, 159, 0.15);
  --glass-shadow: 0 8px 32px rgba(0, 59, 115, 0.4);
}
```

---

## 4. Typography — Pairings para SAJET

| Uso | Font | Import |
|-----|------|--------|
| Display / Headings hero | **Space Grotesk** | Google Fonts |
| UI labels / body | **Inter** | Sistema |
| Monospace / código | **JetBrains Mono** | Google Fonts |
| Dashboard metrics | **Syne** | Google Fonts |

```html
<!-- En app.html o layout.svelte -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;600;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
```

```css
/* Tailwind config */
fontFamily: {
  display: ['Space Grotesk', 'sans-serif'],
  metric: ['Syne', 'sans-serif'],
}
```

---

## 5. Motion — Patrones de Animación (Svelte 5)

Usar **Motion JS API** (no React), ya disponible en el proyecto.

### 5.1 Entrada staggered de elementos
```svelte
<script>
  import { onMount } from 'svelte'
  import { animate, stagger } from 'motion'

  onMount(() => {
    animate(
      '.card-item',
      { opacity: [0, 1], y: [20, 0] },
      { delay: stagger(0.08), duration: 0.5, easing: [0.22, 1, 0.36, 1] }
    )
  })
</script>
```

### 5.2 Scroll-triggered reveal
```svelte
<script>
  import { onMount } from 'svelte'
  import { inView, animate } from 'motion'

  onMount(() => {
    inView('.section-reveal', ({ target }) => {
      animate(target, { opacity: [0, 1], y: [30, 0] }, { duration: 0.6 })
    }, { margin: '-10% 0px' })
  })
</script>
```

### 5.3 Contador animado de métricas
```svelte
<script>
  import { onMount } from 'svelte'
  import { animate } from 'motion'

  let displayValue = $state(0)

  export function animateCounter(target: number) {
    animate(0, target, {
      duration: 1.8,
      easing: [0.22, 1, 0.36, 1],
      onUpdate: (v) => { displayValue = Math.round(v) }
    })
  }
</script>
```

### 5.4 Hover magnético (botones CTA)
```svelte
<script>
  import { animate } from 'motion'

  function handleMouseMove(e: MouseEvent, el: HTMLElement) {
    const rect = el.getBoundingClientRect()
    const x = e.clientX - rect.left - rect.width / 2
    const y = e.clientY - rect.top - rect.height / 2
    animate(el, { x: x * 0.15, y: y * 0.15 }, { duration: 0.2 })
  }

  function handleMouseLeave(el: HTMLElement) {
    animate(el, { x: 0, y: 0 }, { duration: 0.4, easing: 'spring' })
  }
</script>
```

---

## 6. Componentes Base — Glass Design System

### 6.1 GlassCard
```svelte
<!-- GlassCard.svelte -->
<script lang="ts">
  interface Props {
    glow?: boolean
    class?: string
    children?: import('svelte').Snippet
  }
  let { glow = false, class: cls = '', children }: Props = $props()
</script>

<div class="
  relative rounded-2xl border border-white/10 bg-white/5
  backdrop-blur-xl p-6 overflow-hidden
  transition-all duration-300
  hover:border-[#00FF9F]/30 hover:bg-white/8
  {glow ? 'shadow-[0_0_40px_rgba(0,255,159,0.1)]' : ''}
  {cls}
">
  {#if glow}
    <div class="absolute top-0 right-0 w-32 h-32 bg-[#00FF9F]/5 rounded-full blur-3xl"></div>
  {/if}
  {@render children?.()}
</div>
```

### 6.2 MetricCard con animación
```svelte
<!-- MetricCard.svelte -->
<script lang="ts">
  import { onMount } from 'svelte'
  import { animate } from 'motion'

  interface Props {
    label: string
    value: number
    prefix?: string
    suffix?: string
    trend?: number
    icon?: import('svelte').Snippet
  }
  let { label, value, prefix = '', suffix = '', trend, icon }: Props = $props()

  let displayValue = $state(0)

  onMount(() => {
    animate(0, value, {
      duration: 2,
      easing: [0.22, 1, 0.36, 1],
      onUpdate: (v) => { displayValue = Math.round(v) }
    })
  })
</script>

<div class="glass-card group">
  <div class="flex justify-between items-start mb-4">
    <span class="text-sm text-slate-400">{label}</span>
    {@render icon?.()}
  </div>
  <div class="font-metric text-3xl font-bold text-white">
    {prefix}{displayValue.toLocaleString()}{suffix}
  </div>
  {#if trend !== undefined}
    <div class="mt-2 text-sm {trend >= 0 ? 'text-[#00FF9F]' : 'text-red-400'}">
      {trend >= 0 ? '↑' : '↓'} {Math.abs(trend)}%
    </div>
  {/if}
</div>
```

### 6.3 Badge de estado
```svelte
<script lang="ts">
  type Status = 'active' | 'inactive' | 'pending' | 'error'
  interface Props { status: Status; label?: string }
  let { status, label }: Props = $props()

  const config = {
    active:   { dot: 'bg-[#00FF9F] animate-pulse', text: 'text-[#00FF9F]', bg: 'bg-[#00FF9F]/10' },
    inactive: { dot: 'bg-slate-500', text: 'text-slate-400', bg: 'bg-slate-500/10' },
    pending:  { dot: 'bg-amber-400 animate-pulse', text: 'text-amber-400', bg: 'bg-amber-400/10' },
    error:    { dot: 'bg-red-400', text: 'text-red-400', bg: 'bg-red-400/10' },
  }
  const c = $derived(config[status])
</script>

<span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium {c.bg} {c.text}">
  <span class="w-1.5 h-1.5 rounded-full {c.dot}"></span>
  {label ?? status}
</span>
```

---

## 7. Layouts y Patrones de Página

### 7.1 Dashboard SaaS (Dark Glassmorphism)
```
┌─────────────────────────────────────────────────────┐
│  Sidebar (glass, 240px)  │  Main Content (flex-1)   │
│  ─────────────────────   │  ─────────────────────── │
│  Logo + nav items        │  Header (breadcrumb+CTA) │
│  tenant selector         │  Grid 4 MetricCards      │
│  bottom: user avatar     │  2-col: Chart + Table    │
└─────────────────────────────────────────────────────┘
```

### 7.2 Landing Page SaaS (Aurora UI)
```
Hero → Features (3-col) → Social Proof → Pricing → CTA footer
- Aurora gradient background animado
- Scroll-triggered reveals en cada sección
- CTA con hover magnético
- Glassmorphism en pricing cards
```

### 7.3 Auth / Forms (Minimal dark)
```
Center-aligned card sobre bg con noise texture sutil
- Progress steps visuales (multi-step)
- Validación inline con animación de shake
- Success state con confetti o check animado
```

---

## 8. Reglas de Calidad — Checklist Obligatorio

Antes de entregar cualquier componente, verificar:

- [ ] **No emoji en UI** → usar íconos SVG de Lucide Svelte
- [ ] **Hover feedback** → todo elemento interactivo tiene estado hover/focus
- [ ] **Dark mode** → contrastes mínimos WCAG AA (4.5:1 texto, 3:1 UI)
- [ ] **Responsive** → mobile (375px), tablet (768px), desktop (1280px)
- [ ] **Loading states** → skeleton loaders, no spinners genéricos
- [ ] **Empty states** → ilustración + mensaje contextual + CTA
- [ ] **Error states** → feedback visual claro + acción de recuperación
- [ ] **TypeScript** → props con interfaces, no `any`
- [ ] **Svelte 5 runes** → `$state`, `$derived`, `$props()`, Snippets (no slots)
- [ ] **Animaciones accesibles** → respetar `prefers-reduced-motion`

```css
/* Siempre incluir */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## 9. Workflow Obligatorio — Nuevo Proyecto Web

> **REGLA CRÍTICA**: Todo proyecto web nuevo DEBE seguir estos 6 pasos antes de escribir código.
> Esta skill se activa automáticamente para cualquier tarea frontend en `Erp_core/frontend/`.

### Paso 1 — Crear pencil-new.pen

Copiar la plantilla del design system al directorio del proyecto:

```bash
cp design-system/skill/pencil-new.pen <ruta-proyecto>/design/pencil-new.pen
```

Editar el pen con:
- `PROJECT_NAME` → nombre real del proyecto
- `PROJECT_DESC` → stack, objetivo, audiencia  
- Swatches custom si la paleta difiere de SAJET
- Tipografía específica del proyecto

### Paso 2 — Elegir estilo de diseño

Seleccionar UNO de la lista según el contexto:

| # | Estilo | Cuándo usarlo |
|---|--------|---------------|
| 1 | **Glassmorphism Dark** | Dashboards, paneles admin, datos |
| 2 | **Minimal Dark SaaS** | Auth, settings, formularios |
| 3 | **Aurora UI** | Landings, marketing, onboarding |
| 4 | **Brutalist Accent** | Pricing, CTAs, páginas de conversión |
| 5 | **Claymorphism** | Apps educativas, productos consumer |
| 6 | **AI-Native UI** | Chatbots, herramientas IA, generativo |

### Paso 3 — Seleccionar componentes con MCP magic

**SIEMPRE** ofrecer una lista de opciones al usuario antes de implementar:

```
📦 Opciones para [tipo-componente]:

1. [NombreA] — [descripción + estilo visual + animación]
2. [NombreB] — [descripción + estilo visual + animación]
3. [NombreC] — [descripción + estilo visual + animación]
4. Versión custom → generar desde scratch con design system SAJET

¿Cuál prefieres?
```

Usar el MCP magic para explorar variantes antes de presentar la lista.

### Paso 4 — Documentar Motion Plan

En el `.pen` → frame `COMPONENTS` → bloque `MOTION PLAN`, especificar:
- **Entrada**: qué elementos / animación (fadeIn, staggerReveal)
- **Scroll**: qué secciones tienen scroll-reveal (inView)
- **Hover**: qué CTAs tienen feedback (magnetic, scale, glow)
- **Estados**: loading skeletons, error shake, success pulse

### Paso 5 — Implementar

Usar las utilidades de `$lib/utils/motion.ts` disponibles en el proyecto:

```svelte
<script lang="ts">
  import { onMount } from 'svelte'
  import { staggerReveal, scrollReveal, magneticAction } from '$lib/utils/motion'

  onMount(() => {
    staggerReveal('.card-item')
    scrollReveal('.section-reveal')
  })
</script>
```

### Paso 6 — Verificar Launch Checklist

Completar los `☐` del frame `LAUNCH CHECKLIST` en el `.pen` antes de entregar.

---

## 10. Integración con Magic MCP (21st.dev)

Servidor configurado en `mcp_config.json`. Disponible como `magic__21st_magic_component_builder`.

**Siempre ofrecer opciones — nunca implementar sin confirmar:**

```
🎨 Para tu [Hero Section] tengo estas opciones:

OPCIÓN A — Glassmorphism Hero
  • Fondo: aurora gradient animado con Motion
  • CTA: botón con hover magnético + glow en accent
  • Motion: stagger heading + subtext + CTA al cargar

OPCIÓN B — Minimal Dark Hero
  • Fondo: noise texture sutil sobre bg-base
  • Tipografía: oversized Space Grotesk con #00FF9F accent
  • Motion: clip-path reveal del heading

OPCIÓN C — Split-screen Hero
  • Izquierda: copy + CTA | Derecha: mockup animado
  • Motion: scroll parallax sutil en el mockup

OPCIÓN D — Desde MCP magic (base + adaptación SAJET)

¿Cuál se ajusta mejor?
```

---

## 11. Patrones Específicos SAJET

### Tenant card en dashboard admin
```svelte
<script lang="ts">
  import { animate } from 'motion'
  import { Building2, Users, Activity } from 'lucide-svelte'

  interface Tenant {
    name: string
    subdomain: string
    status: 'active' | 'inactive' | 'pending'
    users: number
    uptime: number
  }
  let { tenant }: { tenant: Tenant } = $props()

  let cardEl: HTMLElement
  onMount(() => {
    animate(cardEl, { opacity: [0, 1], scale: [0.97, 1] }, { duration: 0.4 })
  })
</script>

<article bind:this={cardEl} class="glass-card hover:border-[#00FF9F]/30 cursor-pointer group">
  <div class="flex items-center gap-3 mb-4">
    <div class="w-10 h-10 rounded-xl bg-[#003B73]/50 flex items-center justify-center">
      <Building2 size={20} class="text-[#00FF9F]" />
    </div>
    <div>
      <h3 class="font-semibold text-white">{tenant.name}</h3>
      <p class="text-xs text-slate-500">{tenant.subdomain}.sajet.us</p>
    </div>
    <StatusBadge status={tenant.status} class="ml-auto" />
  </div>
  <div class="grid grid-cols-2 gap-3 text-sm">
    <div class="flex items-center gap-2 text-slate-400">
      <Users size={14} /> {tenant.users} usuarios
    </div>
    <div class="flex items-center gap-2 text-slate-400">
      <Activity size={14} /> {tenant.uptime}% uptime
    </div>
  </div>
</article>
```

---

## 11. Anti-Patrones — NUNCA hacer

- ❌ Fondo blanco puro o gris claro en dashboards → siempre dark-first
- ❌ Gradientes purple/violet genéricos → usar paleta de marca
- ❌ Inter/Roboto/Arial como fuente principal → elegir fuente con carácter
- ❌ Spinners Bootstrap/Material genéricos → skeleton loaders personalizados
- ❌ `any` en TypeScript → tipos explícitos siempre
- ❌ Slots de Svelte 4 → usar Snippets de Svelte 5 (`{#snippet}` / `{@render}`)
- ❌ `framer-motion` import → usar `motion` package (`import { animate } from "motion"`)
- ❌ Layouts centered sin breathing room → espaciado generoso, max-width containers
- ❌ Modales sin backdrop blur → siempre backdrop-blur + overlay oscuro
- ❌ Tablas sin estados hover/selected → feedback visual en cada fila
