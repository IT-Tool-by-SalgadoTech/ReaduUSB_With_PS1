#!/usr/bin/env bash
# ScriptID: ST-LIN-0652  |  658.Close_a_port_fix2.sh
# Firewall-blocks inbound traffic to a port (TCP + UDP) via iptables.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

# ---- ITTOOL HEADER ----
it_detect_distro
printf '\n'
printf '%s%s%s\n' "$C_CY" ' _____ _____  _______ ____   ____  _     ' "$C_RS"
printf '%s%s%s\n' "$C_CY" '|_   _|_   _||__   __/ __ \ / __ \| |    ' "$C_RS"
printf '%s%s%s\n' "$C_CY" '  | |   | |     | | | |  | | |  | | |    ' "$C_RS"
printf '%s%s%s\n' "$C_CY" '  | |   | |     | | | |  | | |  | | |    ' "$C_RS"
printf '%s%s%s\n' "$C_CY" ' _| |_  | |     | | | |__| | |__| | |___ ' "$C_RS"
printf '%s%s%s\n' "$C_CY" '|_____| |_|     |_|  \____/ \____/|_____|' "$C_RS"
printf '\n'
echo "${C_WH}  ==================================================================${C_RS}"
echo "${C_CY}  IT-Tool by SalgadoTech${C_RS}"
echo "${C_CY}  Script: 652.Close_a_port_fix2.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0652${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Firewall & Ports${C_RS}"
echo "${C_CY}  Description: Creates inbound firewall Block rules (TCP+UDP) for a chosen port${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
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
