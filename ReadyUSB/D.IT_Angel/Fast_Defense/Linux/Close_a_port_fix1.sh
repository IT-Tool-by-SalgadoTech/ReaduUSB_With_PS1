#!/usr/bin/env bash
# ScriptID: ST-LIN-0657  |  657.Close_a_port_fix1.sh
# Identifies and kills the process (or stops the service) listening on a given TCP/UDP port.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "657.Close_a_port_fix1.sh" "ST-LIN-0657" "Finds and kills the process/service listening on a specified TCP/UDP port"
it_need_root "$@"

port=$(it_ask "  Enter port to close: " "")
if ! printf '%s' "$port" | grep -qE '^[0-9]+$'; then it_err "Invalid port number."; it_pause; exit 1; fi

# Collect owning PIDs from listening TCP + UDP sockets.
pids=$(ss -H -lntup "sport = :$port" 2>/dev/null | grep -oE 'pid=[0-9]+' | cut -d= -f2 | sort -u)

if [ -z "$pids" ]; then
    it_warn "No listener found on port $port."
    it_pause; exit 0
fi

for pid in $pids; do
    pname=$(cat "/proc/$pid/comm" 2>/dev/null || echo "?")
    # Is this PID owned by a systemd service? Then stop the unit cleanly.
    unit=""
    if it_have_systemd; then
        unit=$(systemctl status "$pid" 2>/dev/null | awk 'NR==1{print $2}' | grep '\.service$')
    fi
    if [ -n "$unit" ]; then
        it_run systemctl stop "$unit" && it_ok "Stopped service '$unit' (PID $pid, $pname)."
    else
        it_run kill -TERM "$pid" 2>/dev/null
        sleep 1
        kill -0 "$pid" 2>/dev/null && it_run kill -KILL "$pid" 2>/dev/null
        it_ok "Killed process PID $pid ($pname)."
    fi
done

sleep 1
if ss -H -lntu "sport = :$port" 2>/dev/null | grep -q .; then
    it_err "WARNING: Port $port is still listening."
else
    it_ok "Port $port is now closed."
fi

it_pause
