#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ============================================================================
#  IT-Tool by SalgadoTech
#  Script: 681.Live_Telemetry_Monitor.py
#  ScriptID: ST-WIN-0681-PY
#  Version: 1.0
#  Date: 2026-06-26
#  Category: Windows / Linux > Networks
#  Description: Live outbound telemetry monitor - refreshes every 2s.
#               Shows which process is sending data, to which remote IP/host
#               (reverse DNS), the port, and whether it leaves to the internet
#               (WAN) or stays on the LAN. Press Q or Ctrl+C to exit.
#  (c) 2025 SalgadoTech - All Rights Reserved
#  Unauthorized distribution prohibited
#  Encoding: UTF-8 (no BOM)
# ============================================================================

import os
import sys
import time
import socket
import threading
import ipaddress

try:
    import queue
except ImportError:
    import Queue as queue  # very old python fallback

try:
    import psutil
except ImportError:
    print("  [!] Run:  pip install psutil")
    sys.exit(1)

# ─── ANSI ───────────────────────────────────────────────────────
CYAN    = "\033[96m"
YELLOW  = "\033[93m"
GREEN   = "\033[92m"
RED     = "\033[91m"
ORANGE  = "\033[38;5;208m"
WHITE   = "\033[97m"
GRAY    = "\033[90m"
RESET   = "\033[0m"
BOLD    = "\033[1m"
CLEAR   = "cls" if os.name == "nt" else "clear"
HIDE_C  = "\033[?25l"
SHOW_C  = "\033[?25h"

REFRESH      = 2.0
TOP_N        = 25
RDNS_TIMEOUT = 1.5   # seconds per reverse DNS lookup

_quit = threading.Event()

# ─── Reverse DNS cache (resolved in background to keep the UI fast) ──
_rdns_cache = {}          # ip -> hostname / "-"
_rdns_pending = set()
_rdns_lock = threading.Lock()
_resolve_q = queue.Queue()

def _rdns_worker():
    socket.setdefaulttimeout(RDNS_TIMEOUT)
    while not _quit.is_set():
        try:
            ip = _resolve_q.get(timeout=0.3)
        except queue.Empty:
            continue
        host = "-"
        try:
            host = socket.gethostbyaddr(ip)[0]
        except Exception:
            host = "-"
        with _rdns_lock:
            _rdns_cache[ip] = host
            _rdns_pending.discard(ip)

def get_host(ip):
    with _rdns_lock:
        if ip in _rdns_cache:
            return _rdns_cache[ip]
        if ip not in _rdns_pending:
            _rdns_pending.add(ip)
            _resolve_q.put(ip)
    return "resolving..."

# ─── Scope classification (WAN = leaves to the internet) ────────
def scope(ip):
    try:
        a = ipaddress.ip_address(ip)
    except ValueError:
        return "?"
    if a.is_loopback:
        return "LOCAL"
    if a.is_multicast:
        return "MCAST"
    if a.is_link_local or a.is_private:
        return "LAN"
    return "WAN"

def scope_color(s):
    if s == "WAN":
        return RED
    if s == "LAN":
        return GREEN
    if s == "MCAST":
        return YELLOW
    return GRAY

# ─── Keyboard listener (Q to quit) ──────────────────────────────
def _key_listener():
    try:
        if os.name == "nt":
            import msvcrt
            while not _quit.is_set():
                if msvcrt.kbhit():
                    if msvcrt.getwch().lower() == "q":
                        _quit.set()
                time.sleep(0.05)
        else:
            import tty, termios
            fd  = sys.stdin.fileno()
            old = termios.tcgetattr(fd)
            tty.setraw(fd)
            try:
                while not _quit.is_set():
                    ch = sys.stdin.read(1).lower()
                    if ch in ("q", "\x03"):
                        _quit.set()
            finally:
                termios.tcsetattr(fd, termios.TCSADRAIN, old)
    except Exception:
        pass

# ─── Snapshot: aggregate outbound connections by process + remote IP ─
def snapshot():
    # Build pid -> process name map once per refresh
    pmap = {}
    for p in psutil.process_iter(['pid', 'name']):
        try:
            pmap[p.info['pid']] = p.info['name'] or "-"
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            continue

    denied = False
    try:
        raw = psutil.net_connections(kind='inet')
    except psutil.AccessDenied:
        denied = True
        raw = []
    except Exception:
        raw = []

    agg = {}   # (name, rip) -> dict
    for c in raw:
        if not c.raddr:
            continue
        try:
            rip   = c.raddr.ip
            rport = c.raddr.port
        except Exception:
            continue
        # Skip loopback chatter, keep everything that leaves this host
        sc = scope(rip)
        if sc == "LOCAL":
            continue
        name = pmap.get(c.pid, "-") if c.pid else "-"
        key  = (name, rip)
        if key not in agg:
            agg[key] = {
                "name":   name,
                "pid":    c.pid,
                "rip":    rip,
                "scope":  sc,
                "ports":  set(),
                "states": set(),
                "count":  0,
            }
        agg[key]["ports"].add(rport)
        if c.status:
            agg[key]["states"].add(c.status)
        agg[key]["count"] += 1

    rows = list(agg.values())
    # WAN first, then by connection count
    order = {"WAN": 0, "MCAST": 1, "LAN": 2, "?": 3}
    rows.sort(key=lambda r: (order.get(r["scope"], 9), -r["count"]))
    return rows, denied

# ─── Header ─────────────────────────────────────────────────────
HEADER = (
    f"\n"
    f"{CYAN} _____ _____  _______ ____   ____  _     {RESET}\n"
    f"{CYAN}|_   _|_   _||__   __/ __ \\ / __ \\| |    {RESET}\n"
    f"{CYAN}  | |   | |     | | | |  | | |  | | |    {RESET}\n"
    f"{CYAN}  | |   | |     | | | |  | | |  | | |    {RESET}\n"
    f"{CYAN} _| |_  | |     | | | |__| | |__| | |___ {RESET}\n"
    f"{CYAN}|_____| |_|     |_|  \\____/ \\____/|_____|{RESET}\n"
    f"\n"
    f"{WHITE}  {'=' * 78}{RESET}\n"
    f"{CYAN}  IT-Tool by SalgadoTech{RESET}\n"
    f"{GRAY}  Script: 681.Live_Telemetry_Monitor.py  |  ScriptID: ST-WIN-0681-PY  |  v1.0{RESET}\n"
    f"{GRAY}  Live Outbound Telemetry  -  who is sending, to whom, and where  -  [Q] Quit{RESET}\n"
    f"{WHITE}  {'=' * 78}{RESET}\n"
)

# ─── Render ─────────────────────────────────────────────────────
def render(rows, denied, elapsed):
    os.system(CLEAR)
    out = [HEADER]

    wan = sum(1 for r in rows if r["scope"] == "WAN")
    lan = sum(1 for r in rows if r["scope"] == "LAN")
    hosts = len(set(r["rip"] for r in rows))

    out.append("")
    out.append(f"  {WHITE}Active outbound endpoints:{RESET} {len(rows)}   "
               f"{RED}WAN(internet): {wan}{RESET}   "
               f"{GREEN}LAN: {lan}{RESET}   "
               f"{GRAY}unique hosts: {hosts}{RESET}")
    if denied:
        out.append(f"  {YELLOW}Note: limited visibility. Run as Administrator/root to see all "
                   f"processes.{RESET}")
    out.append("")

    hdr = (f"  {'PID':>6}  {'PROCESS':<20}  {'REMOTE IP':<16}  {'PORTS':<14}  "
           f"{'SCOPE':<6}  {'HOST (reverse DNS)':<28}  {'STATE':<12}")
    out.append(BOLD + WHITE + hdr + RESET)
    out.append(GRAY + "  " + "-" * (len(hdr) - 2) + RESET)

    if not rows:
        out.append(f"  {GRAY}(no outbound connections detected){RESET}")
    else:
        for r in rows[:TOP_N]:
            sc   = r["scope"]
            scol = scope_color(sc)
            host = get_host(r["rip"])
            if len(host) > 28:
                host = host[:27] + "+"
            ports = ",".join(str(p) for p in sorted(r["ports"])[:4])
            if len(r["ports"]) > 4:
                ports += ",+"
            state = ",".join(sorted(r["states"]))[:12] if r["states"] else "-"
            pid_s = str(r["pid"]) if r["pid"] else "-"
            out.append(
                f"  {GRAY}{pid_s:>6}{RESET}  "
                f"{WHITE}{r['name'][:20]:<20}{RESET}  "
                f"{scol}{r['rip']:<16}{RESET}  "
                f"{GRAY}{ports:<14}{RESET}  "
                f"{scol}{sc:<6}{RESET}  "
                f"{CYAN}{host:<28}{RESET}  "
                f"{GRAY}{state:<12}{RESET}"
            )
        if len(rows) > TOP_N:
            out.append(f"  {GRAY}... and {len(rows) - TOP_N} more endpoint(s){RESET}")

    out.append("")
    out.append(f"{GRAY}  Refresh: {REFRESH}s  |  Uptime: {elapsed}s  |  "
               f"WAN rows in red leave this machine to the internet  |  [Q] Quit{RESET}")

    sys.stdout.write("\n".join(out) + "\n")
    sys.stdout.flush()

# ─── Main ───────────────────────────────────────────────────────
def main():
    sys.stdout.write(HIDE_C)
    sys.stdout.flush()

    t_dns = threading.Thread(target=_rdns_worker, daemon=True)
    t_dns.start()
    t_key = threading.Thread(target=_key_listener, daemon=True)
    t_key.start()

    start = time.time()
    try:
        while not _quit.is_set():
            rows, denied = snapshot()
            elapsed = int(time.time() - start)
            render(rows, denied, elapsed)
            for _ in range(int(REFRESH / 0.1)):
                if _quit.is_set():
                    break
                time.sleep(0.1)
    except KeyboardInterrupt:
        _quit.set()
    finally:
        sys.stdout.write(SHOW_C + "\n")
        sys.stdout.flush()
        print(YELLOW + "\n  Telemetry monitor stopped." + RESET)

if __name__ == "__main__":
    main()