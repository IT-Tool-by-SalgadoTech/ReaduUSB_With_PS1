#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Wi-Fi_Off.sh
# Disables all Wi-Fi radios on the system.
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
echo "${C_CY}  Script: Wi-Fi_Off.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Networks${C_RS}"
echo "${C_CY}  Description: Disables all Wi-Fi radios/adapters on the system${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

done_any=0

# 1) NetworkManager radio switch (cleanest when NM is in charge).
if command -v nmcli >/dev/null 2>&1 && nmcli -t g >/dev/null 2>&1; then
    it_run nmcli radio wifi off && it_ok "NetworkManager: Wi-Fi radio turned off." && done_any=1
fi

# 2) rfkill soft-block (works even without NM).
if it_install rfkill rfkill util-linux util-linux; then
    if rfkill list wifi 2>/dev/null | grep -qi -e wlan -e wireless -e wifi; then
        it_run rfkill block wifi && it_ok "Wi-Fi radio(s) soft-blocked via rfkill." && done_any=1
    fi
fi

# 3) Directly down any wireless interface as a last resort.
for ifc in $(ls /sys/class/net 2>/dev/null); do
    if [ -d "/sys/class/net/$ifc/wireless" ] || [ -e "/sys/class/net/$ifc/phy80211" ]; then
        it_run ip link set "$ifc" down && it_ok "Interface '$ifc' brought down." && done_any=1
    fi
done

[ "$done_any" -eq 0 ] && it_warn "No active Wi-Fi adapters found on this host."
it_pause
