/**
 * tailwind.config.ts — argo-web Design Tokens
 * Extend your project's Tailwind config with these tokens.
 */

import type { Config } from 'tailwindcss'

export default {
  content: ['./src/**/*.{html,js,ts,svelte,jsx,tsx,vue}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // Brand
        primary: {
          DEFAULT: '#003B73',
          light: '#0055a8',
          dark: '#002147',
        },
        accent: {
          DEFAULT: '#00FF9F',
          dim: '#00cc7a',
        },
        // Backgrounds
        base: '#0a0f1e',
        surface: '#111827',
        elevated: '#1a2235',
        // Text
        'text-primary': '#f0f4ff',
        'text-secondary': '#94a3b8',
        'text-muted': '#475569',
      },
      fontFamily: {
        display: ['Space Grotesk', 'sans-serif'],
        metric: ['Syne', 'sans-serif'],
        body: ['Inter', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      boxShadow: {
        glass: '0 8px 32px rgba(0, 59, 115, 0.4)',
        'glow-accent': '0 0 40px rgba(0, 255, 159, 0.12)',
        'glow-primary': '0 0 40px rgba(0, 59, 115, 0.25)',
      },
      backdropBlur: {
        glass: '20px',
      },
      backgroundImage: {
        'gradient-brand': 'linear-gradient(135deg, #003B73 0%, #0a0f1e 100%)',
        'gradient-accent': 'linear-gradient(135deg, #00FF9F22 0%, transparent 60%)',
      },
    },
  },
  plugins: [],
} satisfies Config
