# argo-web — Workflow Obligatorio por Pantalla

> **Regla de oro**: Ninguna línea de código se escribe sin un diseño Pencil aprobado.

---

## Reglas Fundamentales

1. **Pencil-first**: toda pantalla nueva comienza con un archivo `.pen`
2. **Approve-before-code**: el diseño debe ser aprobado explícitamente antes de implementar
3. **1:1 implementation**: el código debe coincidir exactamente con el diseño aprobado
4. **Folder-per-screen**: cada pantalla tiene su propia carpeta de documentación
5. **Motion siempre**: toda pantalla tiene un motion plan documentado
6. **Opciones antes de implementar**: siempre presentar lista de componentes al cliente/equipo

---

## Estructura de Carpetas por Pantalla

```
design/
└── screens/
    └── <nombre-pantalla>/
        ├── 01-pencil.pen         # OBLIGATORIO — Diseño visual en Pencil
        ├── 02-approval.md        # OBLIGATORIO — Firma de aprobación
        ├── 03-flow-ascii.md      # Flujo de navegación en ASCII
        ├── 04-components.md      # Lista de componentes seleccionados
        ├── 05-db-model.md        # Modelo de base de datos (si aplica)
        └── 06-motion-plan.md     # Plan de animaciones elemento a elemento
```

---

## Paso 1 — Diseño en Pencil

### Qué debe contener el .pen

El archivo `01-pencil.pen` debe incluir los siguientes frames:

| Frame | Contenido | Obligatorio |
|-------|-----------|-------------|
| `PROJECT COVER` | Nombre, stack, versión, fecha | ✅ |
| `DESIGN TOKENS` | Paleta de colores, tipografía | ✅ |
| `COMPONENTS` | Slots de componentes + motion plan | ✅ |
| `WIREFRAME Desktop` | Layout 1280px | ✅ |
| `WIREFRAME Mobile` | Layout 375px | ✅ |
| `LAUNCH CHECKLIST` | Design QA + Code QA + Motion QA | ✅ |
| `DARK MODE` | Variante dark (si aplica) | ⚡ |
| `STATES` | Loading / Empty / Error states | ⚡ |

### Cómo crear el .pen

```bash
# Copiar el template base del repo argo-web
cp templates/screen/01-pencil.pen design/screens/<nombre>/01-pencil.pen

# O usar el script de scaffolding
bash scripts/new-screen.sh "<nombre>" "<descripción>"
```

---

## Paso 2 — Aprobación

**Sin este paso no se escribe código.**

Completar `02-approval.md` con:

```markdown
## Aprobación de Diseño — <Nombre de Pantalla>

- [ ] Paleta de colores correcta
- [ ] Tipografía alineada con design system
- [ ] Responsive: 375px y 1280px revisados
- [ ] Motion plan revisado y aprobado
- [ ] Componentes seleccionados confirmados
- [ ] Estados (loading, empty, error) presentes

**Aprobado por:** _______________
**Fecha:** _______________
**Versión del diseño:** _______________
```

---

## Paso 3 — Flujo ASCII (`03-flow-ascii.md`)

Documentar el flujo de la pantalla elemento a elemento:

```
Ejemplo — Dashboard de Tenants:

USER ARRIVES
     │
     ▼
┌─────────────────┐
│  Sidebar        │  ← fadeIn (0.3s)
│  • Logo         │
│  • Nav items    │  ← stagger (0.07s each)
│  • Tenant sel.  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│  Header                             │  ← fadeIn (delay: 0.1s)
│  Breadcrumb  |  [+ New Tenant] CTA  │
└─────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│  Metric Cards (×4)                  │  ← stagger (delay: 0.08s each)
│  ┌───┐ ┌───┐ ┌───┐ ┌───┐           │
│  │ M1│ │ M2│ │ M3│ │ M4│           │  ← counter animate on mount
│  └───┘ └───┘ └───┘ └───┘           │
└─────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│  [Chart 2/3]    [Table 1/3]         │  ← inView scroll reveal
└─────────────────────────────────────┘
```

---

## Paso 4 — Componentes (`04-components.md`)

Registrar la lista de opciones presentadas y la selección final:

```markdown
## Componentes — <Nombre de Pantalla>

### Hero / Header
**Opciones presentadas:**
1. Option A — Glassmorphism header con blur
2. Option B — Solid dark con border accent
3. Option C — Minimal con breadcrumb inline

**Seleccionado:** Option B — Solid dark con border accent
**Fuente:** MCP magic / Design system base / Custom

### Cards de métricas
...
```

---

## Paso 5 — Modelo BDA (`05-db-model.md`)

Solo completar si la pantalla consume o modifica datos:

```markdown
## Modelo BDA — <Nombre de Pantalla>

### Tablas involucradas

| Tabla | Operación | Campos usados |
|-------|-----------|---------------|
| `tenants` | SELECT | id, name, subdomain, status |
| `users` | SELECT COUNT | tenant_id |

### Queries principales

```sql
-- Listado de tenants con conteo de usuarios
SELECT t.id, t.name, t.subdomain, t.status,
       COUNT(u.id) as user_count
FROM tenants t
LEFT JOIN users u ON u.tenant_id = t.id
GROUP BY t.id;
```

### API endpoints

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/tenants` | Listado paginado |
| GET | `/api/tenants/:id/stats` | Métricas por tenant |
```

---

## Paso 6 — Motion Plan (`06-motion-plan.md`)

```markdown
## Motion Plan — <Nombre de Pantalla>

### Librería
`motion` v12 — `import { animate, stagger, inView } from "motion"`

### Elementos y animaciones

| Elemento | Trigger | Animación | Duración | Easing |
|----------|---------|-----------|----------|---------|
| Sidebar | onMount | fadeIn (x: -20→0) | 0.3s | easeOutExpo |
| Nav items | onMount | stagger opacity+y | 0.5s | easeOutExpo |
| Metric cards | onMount | stagger scale+opacity | 0.5s | easeOutExpo |
| Counters | onMount | counterAnimate 0→N | 1.8s | easeOutExpo |
| Sections | scroll | inView fadeIn+y | 0.6s | easeOutExpo |
| CTA buttons | hover | magnetic x/y | 0.2s | easeOutExpo |
| Error inputs | error | shakeError | 0.5s | easeInOut |

### prefers-reduced-motion
- [ ] Implementado — todas las animaciones envueltas en `shouldReduceMotion()`
```

---

## Checklist Final Pre-PR

```
☐ 01-pencil.pen — diseño completo con todos los frames
☐ 02-approval.md — firmado por el responsable
☐ 03-flow-ascii.md — flujo documentado elemento a elemento
☐ 04-components.md — componentes seleccionados registrados
☐ 05-db-model.md — modelo BDA completado (o N/A marcado)
☐ 06-motion-plan.md — todas las animaciones documentadas
☐ Implementación 1:1 con el diseño aprobado
☐ prefers-reduced-motion implementado
☐ TypeScript sin any
☐ Tests visuales pasando
```
