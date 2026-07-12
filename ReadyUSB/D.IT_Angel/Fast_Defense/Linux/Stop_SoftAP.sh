#!/usr/bin/env bash
# ScriptID: ST-LIN-0666  |  669.Stop_SoftAP.sh
# Stops any Wi-Fi hosted network / SoftAP so the machine stops acting as an access point.
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
echo "${C_CY}  Script: 666.Stop_SoftAP.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0666${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Networks${C_RS}"
echo "${C_CY}  Description: Stops the Wi-Fi hosted network / SoftAP (hostapd, NetworkManager hotspot)${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

done_any=0

# 1) NetworkManager hotspot connections (type 802-11-wireless, mode ap).
if command -v nmcli >/dev/null 2>&1 && nmcli -t g >/dev/null 2>&1; then
    aps=$(nmcli -t -f NAME,TYPE con show --active 2>/dev/null | awk -F: '$2 ~ /wireless/ {print $1}')
    for ap in $aps; do
        mode=$(nmcli -t -f 802-11-wireless.mode con show "$ap" 2>/dev/null | cut -d: -f2)
        if [ "$mode" = "ap" ]; then
            it_run nmcli con down "$ap" >/dev/null 2>&1
            it_ok "NetworkManager hotspot '$ap' brought down."
            done_any=1
        fi
    done
fi

# 2) hostapd service / process.
if it_service_exists hostapd; then
    it_service_stop hostapd; it_service_disable hostapd
    it_ok "hostapd service stopped and disabled."; done_any=1
elif pgrep -x hostapd >/dev/null 2>&1; then
    it_run pkill -x hostapd && it_ok "hostapd process killed."; done_any=1
fi

# 3) Report any interface still in AP mode.
if command -v iw >/dev/null 2>&1; then
    still=$(iw dev 2>/dev/null | awk '/Interface/{i=$2} /type AP/{print i}')
    [ -n "$still" ] && it_warn "Interface(s) still in AP mode: $still" \
                    || it_ok "No wireless interface is in AP mode."
fi

[ "$done_any" -eq 0 ] && it_note "No active SoftAP/hosted network was found on this host."
it_note "The Windows 'Mobile hotspot' analog here is the GNOME/NM hotspot toggle - turn it off in Settings if present."
it_pause
