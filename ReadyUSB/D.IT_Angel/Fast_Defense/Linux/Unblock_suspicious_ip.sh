#!/usr/bin/env bash
# ScriptID: ST-LIN-0670  |  672.Unblock_suspicious_ip.sh
# Removes IT-Tool firewall blocks created for a suspicious IP.
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
echo "${C_CY}  Script: 670.Unblock_suspicious_ip.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0670${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Networks${C_RS}"
echo "${C_CY}  Description: Removes IT-Tool firewall blocks created for a suspicious IP${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

it_fw_ready || { it_pause; exit 1; }

list="$(it_fw_list_ips)"
if [ -z "$list" ]; then
    it_warn "No IP blocks created by IT-Tool were found."
    it_pause; exit 0
fi

it_info "Currently blocked IP addresses:"
i=0
for ip in $list; do i=$((i+1)); printf '    [%d] %s\n' "$i" "$ip"; done

choice=$(it_ask "Enter the IP to unblock, or type ALL to remove every IT-Tool IP block: " "")
choice="$(printf '%s' "$choice" | tr -d '[:space:]')"
[ -z "$choice" ] && { it_warn "No selection made. Nothing changed."; it_pause; exit 0; }

if [ "$choice" = "ALL" ] || [ "$choice" = "all" ]; then
    n=0
    for ip in $list; do it_fw_unblock_ip "$ip" && n=$((n+1)); done
    it_ok "SUCCESS: Removed IT-Tool blocks for $n IP address(es)."
else
    if ! it_valid_ip "$choice"; then it_err "'$choice' is not a valid IP address."; it_pause; exit 1; fi
    if printf '%s\n' "$list" | grep -qx "$choice"; then
        it_fw_unblock_ip "$choice" && it_ok "SUCCESS: Unblocked '$choice'."
    else
        it_warn "No IT-Tool block found for '$choice'."
    fi
fi

it_pause
