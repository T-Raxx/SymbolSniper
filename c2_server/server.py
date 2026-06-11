"""
C2 Server — Player Sniper Controller
Deploy en Railway / Render / Fly.io (free tier)

Endpoints:
  GET  /state          → Lee el estado actual
  POST /set            → Actualiza target y comando
  POST /stop           → Detiene todos los clientes
  GET  /log            → Ver historial de acciones
"""

from flask import Flask, request, jsonify
from datetime import datetime
import json
import os

app = Flask(__name__)

# ── Autenticación ──────────────────────────────────
API_KEY = os.environ.get("C2_API_KEY", "cambia-esta-clave-secreta")

# ── Estado global (persiste en archivo) ───────────
STATE_FILE = "state.json"

DEFAULT_STATE = {
    "target":  None,
    "command": "idle",   # idle | search | stop | follow
    "active":  False,
    "updated": None,
}

def load_state():
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r") as f:
            return json.load(f)
    return dict(DEFAULT_STATE)

def save_state(state):
    with open(STATE_FILE, "w") as f:
        json.dump(state, f, indent=2)

state = load_state()

# ── Log ────────────────────────────────────────────
LOG_FILE = "activity.log"

def log(msg):
    entry = f"[{datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')} UTC] {msg}"
    print(entry)
    with open(LOG_FILE, "a") as f:
        f.write(entry + "\n")

# ── Auth middleware ────────────────────────────────
def authorized():
    return request.headers.get("X-API-Key") == API_KEY

# ══════════════════════════════════════════════════
#                   ENDPOINTS
# ══════════════════════════════════════════════════

@app.route("/state", methods=["GET"])
def get_state():
    if not authorized():
        return jsonify({"error": "unauthorized"}), 401
    return jsonify(state)

@app.route("/set", methods=["POST"])
def set_state():
    if not authorized():
        return jsonify({"error": "unauthorized"}), 401

    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "body JSON requerido"}), 400

    target  = data.get("target")
    command = data.get("command", "search")

    if not target:
        return jsonify({"error": "falta 'target'"}), 400

    state["target"]  = target
    state["command"] = command
    state["active"]  = True
    state["updated"] = datetime.utcnow().isoformat()
    save_state(state)

    log(f"SET target='{target}' command='{command}'")
    return jsonify({"ok": True, "state": state})

@app.route("/stop", methods=["POST"])
def stop():
    if not authorized():
        return jsonify({"error": "unauthorized"}), 401

    state["command"] = "stop"
    state["active"]  = False
    state["updated"] = datetime.utcnow().isoformat()
    save_state(state)

    log("STOP — todos los clientes detenidos")
    return jsonify({"ok": True, "state": state})

@app.route("/log", methods=["GET"])
def get_log():
    if not authorized():
        return jsonify({"error": "unauthorized"}), 401

    if not os.path.exists(LOG_FILE):
        return jsonify({"log": []})

    with open(LOG_FILE, "r") as f:
        lines = f.read().splitlines()

    limit = int(request.args.get("limit", 50))
    return jsonify({"log": lines[-limit:]})

@app.route("/", methods=["GET"])
def index():
    return jsonify({"status": "C2 online", "active": state["active"]})

# ── Inicio ─────────────────────────────────────────
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
