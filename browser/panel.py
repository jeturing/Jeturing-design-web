#!/usr/bin/env python3
"""
argo-web · browser/panel.py
Servidor de control del navegador embebido.
  GET  /           → Panel HTML
  GET  /current.jpg → Screenshot actual
  GET  /shot        → Captura nueva y devuelve imagen
  POST /api         → {action: screenshot|navigate|scroll|resize|evaluate}

Puerto: 7070
Requiere: pip install websocket-client
"""
import http.server, os, json, base64, urllib.request, time, sys
try:
    import websocket
except ImportError:
    print("Instalando websocket-client...")
    os.system("pip3 install websocket-client --break-system-packages -q")
    import websocket

PORT     = int(os.environ.get("PANEL_PORT", 7070))
CDP_HOST = os.environ.get("CDP_HOST", "localhost:9222")
DIR      = os.path.dirname(os.path.abspath(__file__))
SHOT     = os.path.join(DIR, "current.jpg")

# ── CDP helpers ────────────────────────────────────────────────────────────────
def _get_page():
    tabs = json.loads(urllib.request.urlopen(
        f"http://{CDP_HOST}/json/list", timeout=5).read())
    return next((t for t in tabs if t.get("type") == "page"), None)

def cdp_shot(quality=88):
    try:
        page = _get_page()
        if not page: return False
        ws = websocket.create_connection(page["webSocketDebuggerUrl"], timeout=15)
        # Flush
        ws.settimeout(0.3)
        try:
            while True: ws.recv()
        except: pass
        ws.settimeout(12)
        ws.send(json.dumps({"id":1,"method":"Page.captureScreenshot",
                            "params":{"format":"jpeg","quality":quality}}))
        for _ in range(25):
            try:
                m = json.loads(ws.recv())
                if m.get("id") == 1:
                    img = m.get("result",{}).get("data","")
                    if img:
                        with open(SHOT,"wb") as f:
                            f.write(base64.b64decode(img))
                        ws.close(); return True
            except: break
        ws.close()
    except Exception as e:
        print(f"[CDP] shot error: {e}")
    return False

def cdp_nav(url):
    try:
        page = _get_page()
        if not page: return False
        ws = websocket.create_connection(page["webSocketDebuggerUrl"], timeout=25)
        ws.settimeout(0.3)
        try:
            while True: ws.recv()
        except: pass
        ws.settimeout(20)
        ws.send(json.dumps({"id":1,"method":"Page.navigate","params":{"url":url}}))
        for _ in range(50):
            try:
                m = json.loads(ws.recv())
                if m.get("method") in ("Page.loadEventFired","Page.frameStoppedLoading"):
                    ws.close(); time.sleep(1.5); return True
            except: break
        ws.close(); time.sleep(3); return True
    except Exception as e:
        print(f"[CDP] nav error: {e}"); return False

def cdp_eval(expr):
    try:
        page = _get_page()
        if not page: return None
        ws = websocket.create_connection(page["webSocketDebuggerUrl"], timeout=10)
        ws.settimeout(0.3)
        try:
            while True: ws.recv()
        except: pass
        ws.settimeout(8)
        ws.send(json.dumps({"id":1,"method":"Runtime.evaluate",
                            "params":{"expression":expr,"returnByValue":True}}))
        for _ in range(15):
            try:
                m = json.loads(ws.recv())
                if m.get("id") == 1:
                    ws.close()
                    return m.get("result",{}).get("result",{}).get("value")
            except: break
        ws.close()
    except Exception as e:
        print(f"[CDP] eval error: {e}")
    return None

def cdp_resize(w, h):
    try:
        page = _get_page()
        if not page: return False
        ws = websocket.create_connection(page["webSocketDebuggerUrl"], timeout=10)
        ws.settimeout(0.3)
        try:
            while True: ws.recv()
        except: pass
        ws.settimeout(8)
        ws.send(json.dumps({"id":1,"method":"Emulation.setDeviceMetricsOverride",
            "params":{"width":w,"height":h,"deviceScaleFactor":1,
                      "mobile": w <= 480,"screenWidth":w,"screenHeight":h}}))
        time.sleep(0.5)
        ws.close(); return True
    except: return False

def evaluate_page():
    checks = {
        "CSS variables": "Array.from(document.querySelectorAll('*')).some(el=>getComputedStyle(el).getPropertyValue('--color-primary').trim()!=='')",
        "motion lib":    "!!document.querySelector('script[src*=\"motion\"]') || typeof window.motion !== 'undefined'",
        "SVG icons":     "document.querySelectorAll('svg').length > 0",
        "no emoji icons":"!Array.from(document.querySelectorAll('button,a')).some(el=>/[\u{1F300}-\u{1F9FF}]/u.test(el.textContent))",
        "viewport meta": "!!document.querySelector('meta[name=viewport]')",
        "skeleton/pulse":"!!document.querySelector('[class*=skeleton],[class*=animate-pulse],[class*=shimmer]')",
        "HTTPS":         "location.protocol==='https:'",
    }
    metrics = {}
    score = 0
    for name, expr in checks.items():
        val = cdp_eval(expr)
        ok  = bool(val)
        metrics[name] = {"value": "✅" if ok else "❌", "pass": ok}
        if ok: score += 12
    # Load time
    load = cdp_eval("window.performance?.timing ? Math.round(performance.timing.loadEventEnd - performance.timing.navigationStart) : -1")
    if load and load > 0:
        metrics["load time"] = {"value": f"{load}ms", "pass": load < 3000}
        if load < 3000: score += 16
    # BG color
    bg = cdp_eval("getComputedStyle(document.body).backgroundColor")
    if bg:
        metrics["bg color"] = {"value": str(bg)[:25], "pass": "rgba(0, 0, 0, 0)" not in str(bg)}
    return {"ok": True, "metrics": metrics, "score": min(score, 100)}

# ── HTTP Handler ───────────────────────────────────────────────────────────────
class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a): pass

    def do_HEAD(self):
        self.send_response(200); self.end_headers()

    def do_GET(self):
        p = self.path.split("?")[0]
        if p == "/shot":
            cdp_shot()
            self._file(SHOT, "image/jpeg")
        elif p == "/current.jpg":
            self._file(SHOT, "image/jpeg")
        elif p in ("/", "/index.html"):
            self._file(os.path.join(DIR, "index.html"), "text/html; charset=utf-8")
        else:
            fp = os.path.join(DIR, p.lstrip("/"))
            if os.path.isfile(fp):
                ct = "text/html; charset=utf-8" if fp.endswith(".html") else "application/octet-stream"
                self._file(fp, ct)
            else:
                self.send_response(404); self.end_headers()

    def do_POST(self):
        if self.path != "/api":
            self.send_response(404); self.end_headers(); return
        body = json.loads(self.rfile.read(int(self.headers.get("Content-Length",0))))
        act  = body.get("action","")
        if act == "screenshot":
            res = {"ok": cdp_shot()}
        elif act == "navigate":
            ok = cdp_nav(body.get("url",""))
            if ok: cdp_shot()
            res = {"ok": ok}
        elif act == "resize":
            ok = cdp_resize(body.get("w",1280), body.get("h",900))
            if ok: cdp_shot()
            res = {"ok": ok}
        elif act == "scroll":
            y = body.get("y", 400)
            expr = "window.scrollTo(0,0)" if y < 0 else f"window.scrollBy(0,{y})"
            cdp_eval(expr); time.sleep(0.5); cdp_shot()
            res = {"ok": True}
        elif act == "evaluate":
            res = evaluate_page()
        elif act == "click":
            x, y = body.get("x",0), body.get("y",0)
            page = _get_page()
            if page:
                try:
                    import websocket as _ws
                    w = _ws.create_connection(page["webSocketDebuggerUrl"], timeout=10)
                    w.settimeout(0.3)
                    try:
                        while True: w.recv()
                    except: pass
                    w.settimeout(5)
                    w.send(json.dumps({"id":1,"method":"Input.dispatchMouseEvent",
                        "params":{"type":"mousePressed","x":x,"y":y,"button":"left","clickCount":1}}))
                    time.sleep(0.1)
                    w.send(json.dumps({"id":2,"method":"Input.dispatchMouseEvent",
                        "params":{"type":"mouseReleased","x":x,"y":y,"button":"left","clickCount":1}}))
                    time.sleep(0.5); w.close()
                    cdp_shot()
                except Exception as e:
                    pass
            res = {"ok": True}
        else:
            res = {"ok": False, "error": f"unknown: {act}"}
        self._json(res)

    def _file(self, path, ct):
        try:
            data = open(path,"rb").read()
            self.send_response(200)
            self.send_header("Content-Type", ct)
            self.send_header("Content-Length", str(len(data)))
            self.send_header("Cache-Control", "no-store")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers(); self.wfile.write(data)
        except:
            self.send_response(404); self.end_headers()

    def _json(self, d):
        data = json.dumps(d).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers(); self.wfile.write(data)

if __name__ == "__main__":
    print(f"[argo-web] Capturando screenshot inicial...")
    cdp_shot()
    print(f"[argo-web] Panel en http://localhost:{PORT}/")
    srv = http.server.HTTPServer(("0.0.0.0", PORT), Handler)
    srv.serve_forever()
