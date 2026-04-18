/**
 * motion.ts — argo-web Animation Utilities
 * Framework-agnostic wrapper over the `motion` package (v12+)
 *
 * Install: npm install motion
 * Import:  import { fadeIn, staggerReveal, counterAnimate } from './motion'
 *
 * Works with: Svelte 5, React, Vue 3, Vanilla JS
 */

import { animate, stagger, inView } from 'motion'

// ─── Easing constants ────────────────────────────────────────────────────────

export const EASE_OUT_EXPO = [0.16, 1, 0.3, 1] as const
export const EASE_OUT_BACK = [0.34, 1.56, 0.64, 1] as const
export const EASE_IN_OUT = [0.4, 0, 0.2, 1] as const

// ─── Respects prefers-reduced-motion ─────────────────────────────────────────

export function shouldReduceMotion(): boolean {
  if (typeof window === 'undefined') return false
  return window.matchMedia('(prefers-reduced-motion: reduce)').matches
}

// ─── Fade in + slide up ──────────────────────────────────────────────────────

export function fadeIn(
  el: Element | string,
  options: { delay?: number; duration?: number; y?: number } = {}
) {
  if (shouldReduceMotion()) return
  const { delay = 0, duration = 0.5, y = 20 } = options
  return animate(
    el,
    { opacity: [0, 1], y: [y, 0] },
    { delay, duration, easing: EASE_OUT_EXPO }
  )
}

// ─── Stagger reveal ──────────────────────────────────────────────────────────

export function staggerReveal(
  selector: string,
  options: { delayBetween?: number; duration?: number } = {}
) {
  if (shouldReduceMotion()) return
  const { delayBetween = 0.07, duration = 0.5 } = options
  return animate(
    selector,
    { opacity: [0, 1], y: [16, 0] },
    { delay: stagger(delayBetween), duration, easing: EASE_OUT_EXPO }
  )
}

// ─── Scroll-triggered reveal ─────────────────────────────────────────────────

export function scrollReveal(
  selector: string,
  options: { margin?: string; duration?: number } = {}
) {
  if (shouldReduceMotion()) return
  const { margin = '-10% 0px', duration = 0.6 } = options
  return inView(
    selector,
    ({ target }) => {
      animate(target, { opacity: [0, 1], y: [24, 0] }, { duration, easing: EASE_OUT_EXPO })
    },
    { margin }
  )
}

// ─── Animated metric counter ─────────────────────────────────────────────────

export function counterAnimate(
  from: number,
  to: number,
  onUpdate: (value: number) => void,
  options: { duration?: number } = {}
) {
  if (shouldReduceMotion()) { onUpdate(to); return }
  const { duration = 1.8 } = options
  return animate(from, to, {
    duration,
    easing: EASE_OUT_EXPO,
    onUpdate: (v) => onUpdate(Math.round(v))
  })
}

// ─── Magnetic hover (CTA buttons) ────────────────────────────────────────────

export function setupMagneticHover(el: HTMLElement, strength = 0.15) {
  if (shouldReduceMotion()) return () => {}
  function onMove(e: MouseEvent) {
    const rect = el.getBoundingClientRect()
    const x = (e.clientX - rect.left - rect.width / 2) * strength
    const y = (e.clientY - rect.top - rect.height / 2) * strength
    animate(el, { x, y }, { duration: 0.2, easing: EASE_OUT_EXPO })
  }
  function onLeave() {
    animate(el, { x: 0, y: 0 }, { duration: 0.4, easing: 'spring' })
  }
  el.addEventListener('mousemove', onMove)
  el.addEventListener('mouseleave', onLeave)
  return () => {
    el.removeEventListener('mousemove', onMove)
    el.removeEventListener('mouseleave', onLeave)
  }
}

// ─── Badge pulse ─────────────────────────────────────────────────────────────

export function pulseBadge(el: Element | string) {
  if (shouldReduceMotion()) return
  return animate(el, { scale: [1, 1.2, 1] }, { duration: 0.4, easing: EASE_OUT_BACK })
}

// ─── Shake on error ──────────────────────────────────────────────────────────

export function shakeError(el: Element | string) {
  return animate(el, { x: [0, -8, 8, -6, 6, -3, 3, 0] }, { duration: 0.5, easing: EASE_IN_OUT })
}

// ─── Page enter transition ───────────────────────────────────────────────────

export function pageEnter(el: Element | string) {
  if (shouldReduceMotion()) return
  return animate(el, { opacity: [0, 1], scale: [0.99, 1] }, { duration: 0.3, easing: EASE_OUT_EXPO })
}

// ─── Svelte 5 action: use:fadeInAction ───────────────────────────────────────

export function fadeInAction(node: HTMLElement, params: { delay?: number } = {}) {
  node.style.opacity = '0'
  fadeIn(node, params)
  return { destroy() {} }
}

// ─── Svelte 5 action: use:magneticAction ─────────────────────────────────────

export function magneticAction(node: HTMLElement, strength = 0.15) {
  const cleanup = setupMagneticHover(node, strength)
  return { destroy: cleanup }
}
