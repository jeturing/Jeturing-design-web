#!/usr/bin/env bash
# =============================================================================
# new-screen.sh — argo-web screen scaffolding
# Uso: bash scripts/new-screen.sh <slug> "<descripcion>"
# Ejemplo: bash scripts/new-screen.sh login "Pantalla de inicio de sesión"
# =============================================================================

set -e

SCREEN_SLUG="${1:-nueva-pantalla}"
SCREEN_DESC="${2:-Pantalla sin descripción}"
DATE=$(date '+%Y-%m-%d')
BASE_DIR="design/screens/${SCREEN_SLUG}"

if [ -d "$BASE_DIR" ]; then
  echo "❌  Ya existe: $BASE_DIR"
  exit 1
fi

mkdir -p "$BASE_DIR"
echo "✅  Creando carpeta: $BASE_DIR"

# ── 01 — Pencil template ──────────────────────────────────────────────────────
# Buscar el template en varias ubicaciones posibles
PEN_TEMPLATE=""
for loc in \
  "$(dirname "$0")/../skill/pencil-new.pen" \
  "/opt/Erp_core/.claude/skills/design-web/pencil-new.pen" \
  "design-system/skill/pencil-new.pen" \
  "templates/screen/01-pencil.pen"
do
  if [ -f "$loc" ]; then
    PEN_TEMPLATE="$loc"
    break
  fi
done

if [ -n "$PEN_TEMPLATE" ]; then
  cp "$PEN_TEMPLATE" "${BASE_DIR}/01-pencil.pen"
  echo "✅  Copiado: 01-pencil.pen"
else
  echo '{"version":"2.10","_screen":"'"$SCREEN_SLUG"'","children":[]}' > "${BASE_DIR}/01-pencil.pen"
  echo "⚠️   01-pencil.pen creado vacío (template no encontrado)"
fi

# ── 02 — Approval ─────────────────────────────────────────────────────────────
cat > "${BASE_DIR}/02-approval.md" << EOF
# Aprobación de Diseño — ${SCREEN_DESC}

**Slug:** \`${SCREEN_SLUG}\`  
**Fecha creación:** ${DATE}  
**Estado:** ⏳ Pendiente de aprobación

---

## Checklist de Aprobación

- [ ] Paleta de colores correcta y consistente
- [ ] Tipografía alineada con el design system
- [ ] Responsive revisado: 375px y 1280px
- [ ] Motion plan revisado y aprobado
- [ ] Componentes seleccionados confirmados (ver \`04-components.md\`)
- [ ] Estados presentes: loading, empty, error
- [ ] Contraste WCAG AA verificado

---

## Firma

**Aprobado por:** _______________  
**Fecha de aprobación:** _______________  
**Versión del diseño:** v0.1  

> ⚠️ **SIN ESTE ARCHIVO FIRMADO NO SE INICIA EL DESARROLLO**
EOF
echo "✅  Creado: 02-approval.md"

# ── 03 — ASCII Flow ────────────────────────────────────────────────────────────
cat > "${BASE_DIR}/03-flow-ascii.md" << EOF
# Flujo ASCII — ${SCREEN_DESC}

**Pantalla:** \`${SCREEN_SLUG}\`  
**Fecha:** ${DATE}

---

## Flujo de Navegación

\`\`\`
USER ARRIVES
     │
     ▼
┌──────────────────┐
│  [ Elemento 1 ]  │  ← fadeIn (Xs)
└──────────────────┘
         │
         ▼
┌──────────────────┐
│  [ Elemento 2 ]  │  ← stagger (Xs each)
└──────────────────┘
         │
         ▼
[ Completar... ]
\`\`\`

## Estados de la Pantalla

\`\`\`
ESTADO INICIAL
│
├─▶ LOADING → [ Skeleton / Spinner ]
├─▶ EMPTY   → [ Ilustración + CTA ]
├─▶ ERROR   → [ Mensaje + Retry ]
└─▶ SUCCESS → [ Datos reales ]
\`\`\`

## Interacciones Clave

| Elemento | Acción | Resultado |
|----------|--------|----------|
| [ ] | click | [ ] |
| [ ] | hover | [ ] |
| [ ] | submit | [ ] |
EOF
echo "✅  Creado: 03-flow-ascii.md"

# ── 04 — Components ────────────────────────────────────────────────────────────
cat > "${BASE_DIR}/04-components.md" << EOF
# Componentes — ${SCREEN_DESC}

**Pantalla:** \`${SCREEN_SLUG}\`  
**Fecha:** ${DATE}

> Completar ANTES de implementar. Siempre presentar opciones al equipo.

---

## [ Componente Principal ]

**Opciones presentadas:**
1. Opción A — [ descripción + estilo ]
2. Opción B — [ descripción + estilo ]
3. Opción C — [ descripción + estilo ]
4. Custom desde design system

**Seleccionado:** _______________  
**Fuente:** MCP magic / Design system base / Custom

---

## [ Agregar más componentes ]

<!-- Duplicar bloque anterior por cada componente -->
EOF
echo "✅  Creado: 04-components.md"

# ── 05 — DB Model ──────────────────────────────────────────────────────────────
cat > "${BASE_DIR}/05-db-model.md" << EOF
# Modelo BDA — ${SCREEN_DESC}

**Pantalla:** \`${SCREEN_SLUG}\`  
**Fecha:** ${DATE}

> Si la pantalla no consume datos, marcar como N/A.

---

## Estado: [ Completo / En progreso / N/A ]

## Tablas involucradas

| Tabla | Operación | Campos usados |
|-------|-----------|---------------|
| \`[ tabla ]\` | SELECT/INSERT/UPDATE | [ campos ] |

## Queries principales

\`\`\`sql
-- Query 1
\`\`\`

## API Endpoints

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | \`/api/[ ]\` | [ ] |

## Permisos

| Rol | Acceso |
|-----|--------|
| admin | CRUD |
| user | Read only |
EOF
echo "✅  Creado: 05-db-model.md"

# ── 06 — Motion Plan ───────────────────────────────────────────────────────────
cat > "${BASE_DIR}/06-motion-plan.md" << EOF
# Motion Plan — ${SCREEN_DESC}

**Pantalla:** \`${SCREEN_SLUG}\`  
**Fecha:** ${DATE}  
**Librería:** \`motion\` v12 — \`import { animate, stagger, inView } from "motion"\`

---

## Animaciones por Elemento

| Elemento | Trigger | Función | Duración | Easing |
|----------|---------|---------|----------|---------|
| [ ] | onMount | fadeIn | 0.5s | easeOutExpo |
| [ ] | onMount | staggerReveal | 0.5s | easeOutExpo |
| [ ] | scroll | scrollReveal | 0.6s | easeOutExpo |
| [ ] | hover | magnetic | 0.2s | easeOutExpo |
| [ ] | error | shakeError | 0.5s | easeInOut |

## Implementación

\`\`\`typescript
import { onMount } from 'svelte'
import { staggerReveal, scrollReveal } from '\$lib/utils/motion'

onMount(() => {
  staggerReveal('[ selector ]')
  scrollReveal('[ selector ]')
})
\`\`\`

## prefers-reduced-motion

- [ ] Todas las animaciones envueltas en \`shouldReduceMotion()\`
EOF
echo "✅  Creado: 06-motion-plan.md"

# ── Resumen ─────────────────────────────────────────────────────────────────
echo ""
echo "─────────────────────────────────────────────────────────────────"
echo "🎨  argo-web | Nueva pantalla creada: ${SCREEN_SLUG}"
echo "─────────────────────────────────────────────────────────────────"
echo ""
echo " 📁 $BASE_DIR/"
echo "    ├── 01-pencil.pen       ← ABRIR EN PENCIL y diseñar"
echo "    ├── 02-approval.md      ← FIRMAR antes de codear"
echo "    ├── 03-flow-ascii.md    ← Documentar flujo elemento a elemento"
echo "    ├── 04-components.md    ← Elegir componentes (usar MCP magic)"
echo "    ├── 05-db-model.md      ← Definir modelo BDA"
echo "    └── 06-motion-plan.md   ← Planificar animaciones Motion"
echo ""
echo " Próximo paso: Abrir 01-pencil.pen en Pencil y diseñar la pantalla."
echo " Skill: /opt/Erp_core/.claude/skills/design-web/SKILL.md"
echo ""
