#!/usr/bin/env bash
# ScriptID: ST-LIN-0658  |  658.Close_a_port_fix2.sh
# Firewall-blocks inbound traffic to a port (TCP + UDP) via iptables.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "658.Close_a_port_fix2.sh" "ST-LIN-0658" "Creates inbound firewall Block rules (TCP+UDP) for a chosen port"
it_need_root "$@"

port=$(it_ask "  Enter port to block (e.g. 3389): " "")
if ! printf '%s' "$port" | grep -qE '^[0-9]+$'; then it_err "Invalid port number."; it_pause; exit 1; fi

it_fw_ready || { it_pause; exit 1; }

# Remove existing IT-Tool block rules for this port to avoid duplicates.
for b in iptables ip6tables; do
    command -v "$b" >/dev/null 2>&1 || continue
    "$b"-save 2>/dev/null | grep "ITTOOL_Block_Port_${port}_" | while read -r line; do
        it_run "$b" -D ${line#-A } 2>/dev/null
    done
done

for proto in tcp udp; do
    it_run iptables -I INPUT -p "$proto" --dport "$port" \
        -m comment --comment "ITTOOL_Block_Port_${port}_${proto}" -j DROP
done
it_ok "Block rules created for port $port (TCP + UDP inbound)."

echo
it_info "Current firewall rules for port $port:"
iptables-save 2>/dev/null | grep -E "dport $port |--dport $port\b|ITTOOL_Block_Port_${port}_" | sed 's/^/    /' \
    || it_note "  (none listed)"

it_pause
