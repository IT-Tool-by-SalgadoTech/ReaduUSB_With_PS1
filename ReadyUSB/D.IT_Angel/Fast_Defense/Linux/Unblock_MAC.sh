#!/usr/bin/env bash
# ScriptID: ST-LIN-0669  |  673.Unblock_MAC.sh
# Removes IT-Tool firewall blocks created for a device MAC address.
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
echo "${C_CY}  Script: 669.Unblock_MAC.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0669${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Networks${C_RS}"
echo "${C_CY}  Description: Removes IT-Tool firewall blocks created for a device MAC address${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

it_fw_ready || { it_pause; exit 1; }

list="$(it_fw_list_macs | tr 'A-F' 'a-f')"
if [ -z "$list" ]; then
    it_warn "No MAC blocks created by IT-Tool were found."
    it_pause; exit 0
fi

it_info "Currently blocked devices (by MAC):"
i=0
for m in $list; do i=$((i+1)); printf '    [%d] %s\n' "$i" "$m"; done

choice=$(it_ask "Enter the MAC to unblock (any format), or type ALL to remove every MAC block: " "")
craw="$(printf '%s' "$choice" | tr -d '[:space:]')"
[ -z "$craw" ] && { it_warn "No selection made. Nothing changed."; it_pause; exit 0; }

if [ "$craw" = "ALL" ] || [ "$craw" = "all" ]; then
    n=0
    for m in $list; do it_fw_unblock_mac "$m" && n=$((n+1)); done
    it_ok "SUCCESS: Removed IT-Tool blocks for $n MAC(s)."
else
    mac="$(it_norm_mac "$craw")"
    if [ -z "$mac" ]; then it_err "'$choice' is not a valid MAC address (need 12 hex digits)."; it_pause; exit 1; fi
    if printf '%s\n' "$list" | grep -qx "$mac"; then
        it_fw_unblock_mac "$mac" && it_ok "SUCCESS: Unblocked MAC '$mac'."
    else
        it_warn "No IT-Tool block found for MAC '$mac'."
    fi
fi

it_pause
