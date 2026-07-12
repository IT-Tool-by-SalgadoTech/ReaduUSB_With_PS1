#!/usr/bin/env bash
# ScriptID: ST-LIN-0669  |  669.Stop_SoftAP.sh
# Stops any Wi-Fi hosted network / SoftAP so the machine stops acting as an access point.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "669.Stop_SoftAP.sh" "ST-LIN-0669" "Stops the Wi-Fi hosted network / SoftAP (hostapd, NetworkManager hotspot)"
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
