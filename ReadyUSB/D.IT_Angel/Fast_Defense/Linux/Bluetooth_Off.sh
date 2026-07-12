#!/usr/bin/env bash
# ScriptID: ST-LIN-0649  |  653.Bluetooth_Off.sh
# Disables all Bluetooth radios (rfkill) and stops/disables the Bluetooth service.
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
echo "${C_CY}  Script: 649.Bluetooth_Off.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0649${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Bluetooth${C_RS}"
echo "${C_CY}  Description: Disables all Bluetooth radios via rfkill and stops the Bluetooth service${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

done_any=0

if it_install rfkill rfkill util-linux util-linux; then
    if rfkill list bluetooth 2>/dev/null | grep -qi bluetooth; then
        it_run rfkill block bluetooth && it_ok "Bluetooth radio(s) soft-blocked via rfkill." && done_any=1
    else
        it_warn "rfkill reports no Bluetooth radio on this system."
    fi
else
    it_warn "rfkill not available; will rely on the service and bluetoothctl."
fi

# Power the controller down through bluetoothctl if present.
if command -v bluetoothctl >/dev/null 2>&1; then
    it_run bluetoothctl power off >/dev/null 2>&1 && it_ok "Bluetooth controller powered off (bluetoothctl)." && done_any=1
fi

# Stop and disable the bluetooth service.
if it_service_exists bluetooth || it_have_systemd; then
    it_service_stop bluetooth
    it_service_disable bluetooth
    it_ok "Bluetooth service stopped and disabled." ; done_any=1
else
    it_note "No systemd bluetooth service to stop (not running under systemd)."
fi

[ "$done_any" -eq 0 ] && it_warn "No Bluetooth subsystem found to disable on this host."

it_pause
