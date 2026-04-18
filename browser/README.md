# argo-web · Browser Stack

Stack de navegador embebido para evaluar y controlar proyectos web desde cualquier entorno.

## Inicio rápido

```bash
bash browser/start.sh https://tu-proyecto.com
```

Abre en VS Code Simple Browser: `http://localhost:7070/`

## Stack

```
Xvfb :99  →  Chrome (CDP :9222)  →  x11vnc :5900  →  noVNC :6080
                                                         ↕
                                              Panel de control :7070
```

## Puertos

| Puerto | Servicio | URL |
|--------|---------|-----|
| `9222` | Chrome DevTools Protocol | `http://localhost:9222/json` |
| `5900` | VNC raw | — |
| `6080` | noVNC (browser interactivo) | `http://localhost:6080/vnc.html` |
| `7070` | Panel de control + screenshots | `http://localhost:7070/` |

## Panel de control (:7070)

- **▶ Ir** — Navegar a URL
- **↺** — Capturar screenshot
- **⏵** — Auto-refresh cada 8s
- **🎨** — Evaluar página contra criterios design-web
- **📱 / 🖥 / 📋** — Cambiar viewport
- **Click en imagen** — Clic real en Chrome via CDP
- **⬆ / ⬇** — Scroll

## Variables de entorno

```bash
PANEL_PORT=7070   # Puerto del panel
CDP_HOST=localhost:9222  # Chrome DevTools Protocol
```

## Dependencias

```bash
# Debian/Ubuntu/Proxmox
apt-get install -y xvfb x11vnc novnc

# Python
pip3 install websocket-client

# Chrome (ya instalado en /opt/google/chrome/)
```

## Stack-agnostic

Funciona con cualquier proyecto: React, Svelte, Vue, Vanilla JS, Odoo, cualquier URL.
