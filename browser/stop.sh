#!/usr/bin/env bash
# argo-web · browser/stop.sh — Detiene el stack del navegador
pkill -f "argo-web-chrome" 2>/dev/null
pkill -f "panel.py" 2>/dev/null
pkill -f "websockify" 2>/dev/null
pkill -f "x11vnc" 2>/dev/null
pkill -f "Xvfb :99" 2>/dev/null
rm -f /tmp/argo-pids.env
echo "✅ argo-web browser stack detenido"
