#!/usr/bin/env bash
# ScriptID: ST-LIN-0674  |  674.Wi-Fi_Off.sh
# Disables all Wi-Fi radios on the system.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "674.Wi-Fi_Off.sh" "ST-LIN-0674" "Disables all Wi-Fi radios/adapters on the system"
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
