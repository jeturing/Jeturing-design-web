# argo-web — Design System Agnóstico

> **Pencil-first · Approve · Build** — Workflow de diseño UI/UX para cualquier proyecto web. Independiente del stack y la marca.

[![Stack](https://img.shields.io/badge/stack-agnostic-00FF9F?style=flat-square&labelColor=003B73)](https://github.com/jeturing/Jeturing-design-web)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)

---

## ¿Qué es argo-web?

`argo-web` es el **design system y workflow operativo** para la creación de interfaces web. Define:

- Un proceso obligatorio **Pencil → Approval → Code** para cada pantalla nueva
- La skill `design-web` para AI assistants (Claude Code, GitHub Copilot, Cursor, etc.)
- **10 paletas de color curadas** como alternativa a colores AI-genéricos
- Selección interactiva de paleta y stack al crear cada proyecto
- Templates reutilizables de documentación por pantalla
- Utilidades de animación con Motion (framework-agnostic: JS/TS puro)
- **Sin dependencias de framework** — funciona con React, Svelte, Vue, Vanilla JS

---

## Uso rápido

```bash
# Clonar como submódulo en tu proyecto
git submodule add https://github.com/jeturing/Jeturing-design-web design-system

# Crear nueva pantalla (interactivo — pregunta paleta y stack)
bash design-system/scripts/new-screen.sh "login" "Pantalla de inicio de sesión"
```

El script te pregunta:
1. ¿Qué paleta de color quieres? (10 opciones curadas)
2. ¿Qué stack usas? (React / Svelte / Vue / Vanilla JS)

Y genera `design/screens/login/` con los 6 archivos de documentación listos.

---

## Flujo Pencil → Approve → Build

```
📐 DISEÑAR   →   ✅ APROBAR   →   💻 DESARROLLAR
```

```
design/screens/<nombre>/
├── 01-pencil.pen         ← Diseño visual (Pencil) con paleta elegida
├── 02-approval.md        ← ⛔ FIRMAR ANTES DE CODEAR
├── 03-flow-ascii.md      ← Flujo ASCII elemento a elemento
├── 04-components.md      ← Opciones MCP magic + selección final
├── 05-db-model.md        ← Modelo de datos (o N/A)
└── 06-motion-plan.md     ← Plan de animaciones Motion
```

---

## Paletas de Color Curadas (10 opciones)

Para evitar paletas genéricas de IA. El script las presenta con preview de colores:

| # | Nombre | Estilo | Modo |
|---|--------|--------|------|
| 1 | **Dark Tech** | Azul oscuro + verde neón | Dark |
| 2 | **Oxford Legal** | Azul marino + dorado | Light |
| 3 | **Navy Power** | Navy + crimson | Dark |
| 4 | **Dark Luxury** | Negro cálido + salmon | Dark |
| 5 | **Warm Gold** | Puce + dorado | Dark |
| 6 | **Warm Glam** | Carbón + shadow | Light |
| 7 | **Forest Gold** | Verde oscuro + oro | Dark |
| 8 | **Marsala Classic** | Marsala + dusty rose | Light |
| 9 | **Deep Blue Premium** | Royal blue + blue gray | Dark |
| 10 | **Trust Warm** | Puce + gold | Light |

Ver tokens CSS completos en [`palettes/`](palettes/).

**Uso en CSS (siempre variables, nunca valores hardcoded):**

```css
.card {
  background-color: var(--bg-surface);
  color: var(--text-primary);
  border-left: 3px solid var(--color-primary);
}

.btn-primary {
  background-color: var(--color-primary);
  color: var(--text-primary);
}

.btn-primary:hover {
  background-color: var(--color-accent);
  color: var(--bg-base);
}

.metric-highlight {
  color: var(--color-accent);
  font-weight: 700;
}
```

---

## Stacks Soportados

| Stack | Notas |
|-------|-------|
| **React 18+** | Hooks, Server Components, Next.js |
| **Svelte 5** | Runes, Snippets, SvelteKit |
| **Vue 3** | Composition API, Pinia, Nuxt |
| **Vanilla JS/TS** | Motion API directo, sin framework |
| **Tailwind CSS 3/4** | Config con tokens incluida |
| **CSS puro** | Variables CSS para cualquier setup |

---

## Estructura del repo

```
Jeturing-design-web/
├── README.md
├── WORKFLOW.md                  # Workflow detallado con reglas
├── skill/
│   ├── SKILL.md                 # Skill para AI assistants
│   ├── pencil-new.pen           # Template Pencil de proyecto
│   ├── motion.ts                # Utilidades Motion (JS/TS puro)
│   └── tailwind.config.ts       # Design tokens Tailwind
├── palettes/
│   ├── index.md                 # Catálogo visual
│   ├── 01-dark-tech.css         # Dark Tech palette
│   ├── 02-oxford-legal.css      # Oxford Legal palette
│   └── ...                      # 10 paletas en total
├── templates/
│   └── screen/                  # 6 templates por pantalla
├── scripts/
│   └── new-screen.sh            # Scaffolding interactivo
└── examples/
    └── README.md
```

---

> **Regla fundamental:** No se escribe ni una línea de código sin un diseño Pencil aprobado.

*argo-web by [Jeturing](https://jeturing.com)*
