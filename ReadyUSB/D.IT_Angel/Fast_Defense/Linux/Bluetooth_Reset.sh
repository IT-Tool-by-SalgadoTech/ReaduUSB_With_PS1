#!/usr/bin/env bash
# ScriptID: ST-LIN-0650  |  654.Bluetooth_Reset.sh
# Linux analog of the Windows "Swift Pair" reset: hardens fast-pair discovery by
# power-cycling the Bluetooth radio, disabling discoverability and restarting the stack.
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
echo "${C_CY}  Script: 650.Bluetooth_Reset.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0650${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Bluetooth${C_RS}"
echo "${C_CY}  Description: Disables Bluetooth discoverability/fast-pair and resets the Bluetooth stack${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

# 1) Turn off discoverable/pairable so no 'Swift Pair'-style silent pairing happens.
if command -v bluetoothctl >/dev/null 2>&1; then
    it_run bluetoothctl discoverable off >/dev/null 2>&1
    it_run bluetoothctl pairable off     >/dev/null 2>&1
    it_ok "Bluetooth set to non-discoverable and non-pairable."
else
    it_warn "bluetoothctl not found; skipping discoverable/pairable hardening."
fi

# 2) Harden main.conf: no auto fast-connectable, discoverable timeout enforced.
CONF=/etc/bluetooth/main.conf
if [ -f "$CONF" ]; then
    if ! grep -q '^FastConnectable = false' "$CONF" 2>/dev/null; then
        it_run bash -c "printf '\n# Added by IT-Tool 654\nFastConnectable = false\n' >> '$CONF'"
        it_ok "Disabled FastConnectable in $CONF."
    else
        it_note "FastConnectable already disabled in $CONF."
    fi
else
    it_note "$CONF not present; nothing to harden in config."
fi

# 3) Restart the stack: rfkill cycle + service restart.
if it_install rfkill rfkill util-linux util-linux; then
    it_run rfkill block bluetooth   >/dev/null 2>&1
    sleep 1
    it_run rfkill unblock bluetooth >/dev/null 2>&1
    it_ok "Bluetooth radio power-cycled (rfkill)."
fi

if it_have_systemd; then
    it_service_restart bluetooth && it_ok "Bluetooth service restarted." \
        || it_warn "Could not restart the bluetooth service."
else
    it_note "systemd not active; service restart skipped."
fi

it_pause
