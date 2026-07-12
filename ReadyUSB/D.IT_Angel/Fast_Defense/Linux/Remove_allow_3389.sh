#!/usr/bin/env bash
# ScriptID: ST-LIN-0660  |  663.Remove_allow_3389.sh
# Removes any inbound Allow rule for RDP port 3389 (ufw / firewalld / iptables).
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
echo "${C_CY}  Script: 660.Remove_allow_3389.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0660${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Remote Desktop${C_RS}"
echo "${C_CY}  Description: Removes the firewall rule that allows inbound RDP port 3389${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

removed=0

# ufw: delete allow rules for 3389
if command -v ufw >/dev/null 2>&1; then
    for proto in tcp udp; do
        it_run ufw delete allow 3389/$proto >/dev/null 2>&1 && removed=1
    done
    it_run ufw delete allow 3389 >/dev/null 2>&1 && removed=1
    [ "$removed" -eq 1 ] && it_ok "ufw: allow rule(s) for 3389 removed."
fi

# firewalld: remove the rdp service / 3389 port from the default zone
if command -v firewall-cmd >/dev/null 2>&1 && firewall-cmd --state >/dev/null 2>&1; then
    it_run firewall-cmd --permanent --remove-service=rdp >/dev/null 2>&1 && removed=1
    it_run firewall-cmd --permanent --remove-port=3389/tcp >/dev/null 2>&1 && removed=1
    it_run firewall-cmd --reload >/dev/null 2>&1
    it_ok "firewalld: RDP service / port 3389 removed from the active zone."
fi

# iptables: delete ACCEPT rules referencing 3389
if it_fw_ready; then
    for b in iptables ip6tables; do
        command -v "$b" >/dev/null 2>&1 || continue
        "$b"-save 2>/dev/null | grep -E '\-\-dport 3389\b' | grep -E 'ACCEPT' | while read -r line; do
            it_run "$b" -D ${line#-A } 2>/dev/null
        done
    done
    it_ok "iptables: any ACCEPT rule for 3389 removed."
    removed=1
fi

[ "$removed" -eq 0 ] && it_warn "No allow rule for 3389 was found (or no firewall present)."
it_pause
