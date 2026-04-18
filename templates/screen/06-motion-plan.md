# Motion Plan — [ Nombre de Pantalla ]

**Pantalla:** `[ screen-slug ]`  
**Fecha:** YYYY-MM-DD  
**Librería:** `motion` v12+

```typescript
import { animate, stagger, inView } from 'motion'
```

---

## Animaciones por Elemento

| Elemento | Selector CSS | Trigger | Función | Duración | Delay | Easing |
|----------|-------------|---------|---------|----------|-------|--------|
| [ Elemento 1 ] | `.[ cls ]` | onMount | `fadeIn` | 0.5s | 0s | easeOutExpo |
| [ Lista de items ] | `.[ cls ]` | onMount | `staggerReveal` | 0.5s | 0.07s each | easeOutExpo |
| [ Sección ]| `.[ cls ]` | scroll | `scrollReveal` | 0.6s | — | easeOutExpo |
| [ CTA btn ] | `.[ cls ]` | hover | `magnetic` | 0.2s | — | easeOutExpo |
| [ Métrica ] | `.[ cls ]` | onMount | `counterAnimate` | 1.8s | — | easeOutExpo |
| [ Input ] | `.[ cls ]` | error | `shakeError` | 0.5s | — | easeInOut |

---

## Código Base

```typescript
// En tu componente Svelte 5
import { onMount } from 'svelte'
import {
  fadeIn,
  staggerReveal,
  scrollReveal,
  counterAnimate,
  magneticAction,
  shakeError
} from '$lib/utils/motion'
// o desde argo-web:
// import { ... } from '../design-system/skill/motion'

onMount(() => {
  fadeIn('.hero-title', { delay: 0.1 })
  staggerReveal('.card-item', { delayBetween: 0.07 })
  scrollReveal('.section-reveal')
})
```

---

## Estados Animados

### Loading skeleton
```css
@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}
.skeleton {
  background: linear-gradient(90deg, #1a2235 25%, #1e2a40 50%, #1a2235 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}
```

### Error shake
```typescript
import { shakeError } from '$lib/utils/motion'
// Al detectar error de validación:
shakeError('#form-field-email')
```

---

## prefers-reduced-motion

- [ ] Implementado — \`shouldReduceMotion()\` usado en todas las funciones

```css
/* CSS fallback */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```
