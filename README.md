# argo-web — Jeturing Design System

> **Pencil-first · Approve · Build** — Workflow de diseño UI/UX para todos los proyectos Jeturing.

[![Product](https://img.shields.io/badge/product-argo--web-00FF9F?style=flat-square&labelColor=003B73)](https://github.com/jeturing/Jeturing-design-web)
[![Stack](https://img.shields.io/badge/stack-Svelte5+Tailwind+Motion-blue?style=flat-square)](https://github.com/jeturing/Jeturing-design-web)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)

---

## ¿Qué es argo-web?

`argo-web` es el **design system y workflow operativo** de Jeturing para la creación de interfaces web. Define:

- Un proceso obligatorio **Pencil → Approval → Code** para cada pantalla nueva
- La skill `design-web` para AI assistants (Claude Code, GitHub Copilot, Cursor)
- Templates reutilizables de documentación por pantalla
- Utilidades de animación con Motion (JS/Svelte 5)
- Componentes base del Glass Design System

---

## Flujo de trabajo

```
┌─────────────────────────────────────────────────────────────────┐
│  NUEVA PANTALLA / FEATURE WEB                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. DISEÑO EN PENCIL                                            │
│     └─ Crear pencil-new.pen en design/<screen-name>/            │
│        • Tokens de color y tipografía                           │
│        • Selección de componentes (lista MCP magic)             │
│        • Motion plan documentado                                │
│        • Wireframes Desktop + Mobile                            │
│                                                                 │
│  2. APROBACIÓN ✅                                                │
│     └─ Firmar design/<screen-name>/02-approval.md               │
│        • Sin aprobación NO se escribe código                    │
│                                                                 │
│  3. DOCUMENTACIÓN                                               │
│     └─ Completar antes o durante el desarrollo:                 │
│        • 03-flow-ascii.md  → Flujo ASCII elemento a elemento    │
│        • 04-components.md  → Componentes seleccionados          │
│        • 05-db-model.md    → Modelo BDA/DB si aplica            │
│        • 06-motion-plan.md → Animaciones por elemento           │
│                                                                 │
│  4. DESARROLLO 1:1                                              │
│     └─ Implementar exactamente el diseño aprobado               │
│        • Svelte 5 + Tailwind + Motion                           │
│        • Usar componentes elegidos en paso 1                    │
│        • Motion plan implementado con motion.ts utilities       │
│                                                                 │
│  5. LAUNCH CHECKLIST                                            │
│     └─ Completar checklist en el .pen antes de PR               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Estructura del repo

```
Jeturing-design-web/
├── README.md                    # Este archivo
├── WORKFLOW.md                  # Workflow detallado con reglas
├── skill/
│   ├── SKILL.md                 # Skill para AI assistants
│   ├── pencil-new.pen           # Template Pencil para proyectos
│   └── motion.ts                # Utilidades Motion (framework-agnostic)
├── templates/
│   └── screen/
│       ├── 01-pencil.pen        # Template Pencil por pantalla
│       ├── 02-approval.md       # Template de aprobación
│       ├── 03-flow-ascii.md     # Template flujo ASCII
│       ├── 04-components.md     # Template componentes
│       ├── 05-db-model.md       # Template modelo BDA
│       └── 06-motion-plan.md    # Template plan de animaciones
├── scripts/
│   └── new-screen.sh            # Scaffolding de nueva pantalla
└── examples/
    └── saas-dashboard/          # Ejemplo completo
```

---

## Instalación

### En cualquier proyecto

```bash
# Clonar como submódulo (recomendado)
git submodule add https://github.com/jeturing/Jeturing-design-web design-system

# O clonar directo
git clone https://github.com/jeturing/Jeturing-design-web design-system
```

### Script de nueva pantalla

```bash
# Desde la raíz del proyecto
bash design-system/scripts/new-screen.sh "login" "Pantalla de inicio de sesión"
# Crea: design/screens/login/ con todos los templates
```

---

## Paleta de marca SAJET

| Token | Valor | Uso |
|-------|-------|-----|
| `--color-primary` | `#003B73` | Marca, headers, CTAs primarios |
| `--color-accent` | `#00FF9F` | Highlights, estados activos, métricas |
| `--bg-base` | `#0a0f1e` | Background principal dark |
| `--bg-surface` | `#111827` | Cards, sidebars |
| `--text-primary` | `#f0f4ff` | Texto principal |

---

## Stack soportado

| Stack | Notas |
|-------|-------|
| **Svelte 5** | Runes, Snippets, SvelteKit |
| **React 18+** | Hooks, Server Components |
| **Vue 3** | Composition API |
| **Vanilla JS** | Motion API directo |
| **Tailwind CSS 3/4** | Incluye config con tokens |

---

## Contribuir

Ver [WORKFLOW.md](WORKFLOW.md) para el proceso completo.

---

*argo-web by [Jeturing](https://jeturing.com) — Design system que piensa antes de construir.*
