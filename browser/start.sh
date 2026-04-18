#!/usr/bin/env bash
# =============================================================================
# argo-web · browser/start.sh
# Levanta el stack de navegador embebido:
#   Xvfb → Chrome → x11vnc → noVNC → Panel de control (puerto 7070)
#
# Uso:
#   bash browser/start.sh [URL]
#   bash browser/start.sh https://app.sajet.us
#
# Stack-agnostic: funciona en cualquier Linux con Chrome instalado
# Repo: https://github.com/jeturing/Jeturing-design-web
# =============================================================================
set -e

START_URL="${1:-https://localhost}"
DISPLAY_NUM=99
VNC_PORT=5900
NOVNC_PORT=6080
PANEL_PORT=7070
CHROME_DEBUG_PORT=9222
WORKDIR="$(cd "$(dirname "$0")/.." && pwd)"
BROWSER_DIR="$WORKDIR/browser"
SHOT="$BROWSER_DIR/current.jpg"

# ── Colores ───────────────────────────────────────────────────────────────────
G="\033[32m" Y="\033[33m" C="\033[36m" R="\033[0m" B="\033[1m"

echo -e "${B}${C}"
echo "  ┌──────────────────────────────────────────────┐"
echo "  │  argo-web · Browser Stack                    │"
echo "  │  Xvfb → Chrome → noVNC → Panel :7070         │"
echo "  └──────────────────────────────────────────────┘"
echo -e "${R}"

# ── Detectar Chrome ───────────────────────────────────────────────────────────
CHROME=""
for c in \
  "/opt/google/chrome/chrome" \
  "/usr/bin/google-chrome" \
  "/usr/bin/chromium-browser" \
  "/usr/bin/chromium" \
  "$(which google-chrome 2>/dev/null)" \
  "$(which chromium 2>/dev/null)"
do
  if [ -x "$c" ]; then CHROME="$c"; break; fi
done

if [ -z "$CHROME" ]; then
  echo -e "${Y}⚠️  Chrome no encontrado. Instalar con:${R}"
  echo "   apt-get install -y google-chrome-stable"
  echo "   o copiar el binario a /opt/google/chrome/chrome"
  exit 1
fi
echo -e "${G}✅ Chrome: $CHROME${R}"

# ── Dependencias ──────────────────────────────────────────────────────────────
for pkg in xvfb x11vnc websockify; do
  if ! command -v "$pkg" &>/dev/null; then
    echo -e "${Y}Instalando $pkg...${R}"
    apt-get install -y "$pkg" 2>/dev/null || pip3 install websockify 2>/dev/null || true
  fi
done

NOVNC_WEB=""
for d in /usr/share/novnc /usr/local/share/novnc; do
  [ -d "$d" ] && NOVNC_WEB="$d" && break
done
[ -z "$NOVNC_WEB" ] && apt-get install -y novnc 2>/dev/null && NOVNC_WEB="/usr/share/novnc"

# ── Limpiar procesos anteriores ───────────────────────────────────────────────
bash "$BROWSER_DIR/stop.sh" 2>/dev/null || true
sleep 1
rm -f "/tmp/.X${DISPLAY_NUM}-lock" 2>/dev/null || true

# ── Xvfb ──────────────────────────────────────────────────────────────────────
Xvfb ":${DISPLAY_NUM}" -screen 0 1280x900x24 -ac -noreset &
sleep 2
echo -e "${G}✅ Xvfb :${DISPLAY_NUM}${R}"

# ── Chrome ────────────────────────────────────────────────────────────────────
DISPLAY=":${DISPLAY_NUM}" "$CHROME" \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --start-maximized \
  --window-size=1280,900 \
  --remote-debugging-port="${CHROME_DEBUG_PORT}" \
  --remote-debugging-address=0.0.0.0 \
  --remote-allow-origins='*' \
  --user-data-dir="/tmp/argo-web-chrome" \
  "$START_URL" &>/tmp/argo-chrome.log &
sleep 4
echo -e "${G}✅ Chrome → ${START_URL}${R}"

# ── x11vnc ────────────────────────────────────────────────────────────────────
x11vnc -display ":${DISPLAY_NUM}" -nopw -rfbport "${VNC_PORT}" \
  -forever -shared -bg -o /tmp/argo-vnc.log
sleep 1
echo -e "${G}✅ x11vnc :${VNC_PORT}${R}"

# ── noVNC ─────────────────────────────────────────────────────────────────────
websockify --web "$NOVNC_WEB" "${NOVNC_PORT}" "localhost:${VNC_PORT}" \
  &>/tmp/argo-novnc.log &
sleep 1
echo -e "${G}✅ noVNC :${NOVNC_PORT}${R}"

# ── Panel de control ──────────────────────────────────────────────────────────
python3 "$BROWSER_DIR/panel.py" &>/tmp/argo-panel.log &
sleep 2
echo -e "${G}✅ Panel :${PANEL_PORT}${R}"

echo ""
echo -e "${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
echo -e "${B}${G}  LISTO${R}"
echo ""
echo -e "  ${C}Panel control:${R}  http://localhost:${PANEL_PORT}/"
echo -e "  ${C}noVNC (live):${R}   http://localhost:${NOVNC_PORT}/vnc.html?autoconnect=true"
echo -e "  ${C}CDP:${R}            http://localhost:${CHROME_DEBUG_PORT}/json"
echo ""
echo -e "  ${Y}VS Code Simple Browser → http://localhost:${PANEL_PORT}/${R}"
echo -e "${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
echo ""

# Guardar PIDs
echo "XVFB=$(pgrep -f "Xvfb :${DISPLAY_NUM}")" > /tmp/argo-pids.env
echo "CHROME=$(pgrep -f "chrome.*argo-web-chrome" | head -1)" >> /tmp/argo-pids.env
echo "VNC=$(pgrep -f x11vnc)" >> /tmp/argo-pids.env
echo "NOVNC=$(pgrep -f websockify)" >> /tmp/argo-pids.env
echo "PANEL=$(pgrep -f "panel.py")" >> /tmp/argo-pids.env
