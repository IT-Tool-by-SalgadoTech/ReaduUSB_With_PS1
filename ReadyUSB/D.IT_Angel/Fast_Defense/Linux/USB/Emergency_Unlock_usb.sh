#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Emergency_Unlock_usb.sh
# Master USB recovery. Reverses every USB lock mechanism used by 647 in one pass.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

STATE_DIR=/var/lib/ittool
STATE_FILE="$STATE_DIR/usb_lock_state.txt"
UDEV_RULE=/etc/udev/rules.d/99-ittool-usb-lock.rules

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
echo "${C_CY}  Script: Emergency_Unlock_usb.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > USB${C_RS}"
echo "${C_CY}  Description: Master USB recovery: reverses every USB lock mechanism from 647${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

# --- 1) Remove the udev lock rule ------------------------------------------
it_info "[1] udev lock rule"
if [ -f "$UDEV_RULE" ]; then
    it_run rm -f "$UDEV_RULE" && it_ok "Removed $UDEV_RULE"
    it_run udevadm control --reload-rules 2>/dev/null
else
    it_note "Not present: $UDEV_RULE"
fi

# --- 2) Re-enable new-device authorization on all controllers --------------
it_info "[2] Controller authorized_default"
for ctrl in /sys/bus/usb/devices/usb*; do
    [ -w "$ctrl/authorized_default" ] || continue
    it_run bash -c "echo 1 > '$ctrl/authorized_default'" \
        && it_ok "New USB devices accepted on $(basename "$ctrl")."
done

# --- 3) Re-authorise every connected USB device ----------------------------
it_info "[3] Re-authorising connected devices"
fixed=0
for d in /sys/bus/usb/devices/*; do
    [ -w "$d/authorized" ] || continue
    if [ "$(cat "$d/authorized" 2>/dev/null)" != "1" ]; then
        it_run bash -c "echo 1 > '$d/authorized'" && fixed=$((fixed+1))
    fi
done
it_ok "Re-enabled $fixed USB device(s)."

# --- 4) Restore usb-storage ------------------------------------------------
it_info "[4] Storage driver"
if [ -f /etc/modprobe.d/99-ittool-usb-storage.conf ]; then
    it_run rm -f /etc/modprobe.d/99-ittool-usb-storage.conf && it_ok "usb-storage block removed."
fi
it_run modprobe usb_storage 2>/dev/null && it_ok "usb-storage module loaded." \
    || it_note "usb-storage will load on demand when a drive is inserted."

# --- 5) Trigger a rescan ----------------------------------------------------
it_info "[5] Rescan"
it_run udevadm trigger 2>/dev/null && it_ok "Hardware rescan triggered."

# --- 6) Archive the lock state file ----------------------------------------
if [ -f "$STATE_FILE" ]; then
    it_run mv -f "$STATE_FILE" "${STATE_FILE%.txt}_$(date +%Y%m%d_%H%M%S).bak" 2>/dev/null
    it_note "Lock state archived."
fi

if [ ! -w /sys/bus/usb/devices/usb1/authorized_default ] && [ "$fixed" -eq 0 ]; then
    it_warn "sysfs USB controls are not writable here (container/limited host)."
    it_note "On a real host this restores full USB access immediately."
fi

it_ok "USB ACCESS RESTORED. Unplug and reconnect your device; reboot once if it still shows access denied."
it_pause
