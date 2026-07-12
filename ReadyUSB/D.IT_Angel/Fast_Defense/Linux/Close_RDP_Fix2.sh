#!/usr/bin/env bash
# ScriptID: ST-LIN-0655  |  656.Close_RDP_Fix2.sh
# Fully blocks RDP: stops/disables the RDP services AND blocks port 3389 (TCP/UDP) in the firewall.
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
echo "${C_CY}  Script: 655.Close_RDP_Fix2.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0655${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Remote Desktop${C_RS}"
echo "${C_CY}  Description: Fully blocks RDP: stops xrdp/GNOME RDP and firewall-blocks port 3389 (TCP/UDP)${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

# --- Services ---
for svc in xrdp xrdp-sesman gnome-remote-desktop; do
    if it_service_exists "$svc"; then
        it_service_stop "$svc"; it_service_disable "$svc"
        it_ok "Service '$svc' stopped and disabled."
    fi
done

# --- Firewall block on 3389 ---
if it_fw_ready; then
    # remove any stale IT-Tool 3389 rules first
    for b in iptables ip6tables; do
        command -v "$b" >/dev/null 2>&1 || continue
        "$b"-save 2>/dev/null | grep "ITTOOL_Block_Port_3389" | while read -r line; do
            it_run "$b" -D ${line#-A } 2>/dev/null
        done
    done
    for proto in tcp udp; do
        it_run iptables -I INPUT -p "$proto" --dport 3389 \
            -m comment --comment "ITTOOL_Block_Port_3389_${proto}" -j DROP
    done
    it_ok "Firewall: inbound TCP/UDP 3389 dropped (tagged ITTOOL_Block_Port_3389)."
    echo
    it_info "Current firewall rules for port 3389:"
    iptables-save 2>/dev/null | grep '3389' | sed 's/^/    /' || it_note "  (none listed)"
else
    it_warn "Firewall block skipped (no firewall access)."
fi

echo
if ss -H -lnt 2>/dev/null | grep -q ':3389'; then
    it_warn "A process is still LISTENING on 3389, but new inbound packets are now dropped."
else
    it_ok "Nothing is listening on 3389 and the port is firewalled."
fi

it_pause
