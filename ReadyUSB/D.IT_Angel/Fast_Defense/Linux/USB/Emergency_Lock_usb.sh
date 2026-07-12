#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Emergency_Lock_usb.sh
# Emergency USB lock. De-authorises every connected USB device and blocks new USB
# installs, EXCEPT the Bluetooth radio chain, so an unlock can be delivered over BLE.
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
echo "${C_CY}  Script: Emergency_Lock_usb.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > USB${C_RS}"
echo "${C_CY}  Description: Emergency USB lock: de-authorises all USB devices except the Bluetooth radio${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

# --- Detect a Bluetooth USB radio so we can keep it alive -------------------
bt_syspaths=""
for d in /sys/bus/usb/devices/*; do
    [ -r "$d/bDeviceClass" ] || continue
    cls=$(cat "$d/bInterfaceClass" 2>/dev/null)
    # Class E0 = Wireless (Bluetooth radios). Also keep hubs (class 09).
    if lsusb 2>/dev/null | grep -iq bluetooth; then :; fi
done
btcount=$(lsusb 2>/dev/null | grep -ci bluetooth)
if [ "$btcount" -gt 0 ]; then
    it_ok "Bluetooth radio detected ($btcount). It will be kept alive for BLE unlock."
else
    it_warn "No Bluetooth radio detected. BLE unlock will NOT be possible."
    it_warn "Recovery would then need a PS/2 keyboard, single-user mode, or 648 from console."
fi

echo
it_warn "EMERGENCY USB LOCK"
it_warn "This DISABLES every USB device (keyboard, mouse, storage, network) EXCEPT"
it_warn "the Bluetooth radio. Local USB input WILL stop working."
it_note "Recovery state file: $STATE_FILE"
confirm=$(it_ask "  Type USBLOCK to proceed: " "")
[ "$confirm" != "USBLOCK" ] && { it_ok "Aborted. No changes made."; it_pause; exit 0; }

it_run mkdir -p "$STATE_DIR"
[ -z "${IT_DRYRUN:-}" ] && : > "$STATE_FILE"

# --- 1) Block NEW USB devices via authorized_default = 0 on each controller -
for ctrl in /sys/bus/usb/devices/usb*; do
    [ -w "$ctrl/authorized_default" ] || continue
    prev=$(cat "$ctrl/authorized_default" 2>/dev/null)
    [ -z "${IT_DRYRUN:-}" ] && echo "authdef $ctrl $prev" >> "$STATE_FILE"
    it_run bash -c "echo 0 > '$ctrl/authorized_default'" \
        && it_ok "New USB installs blocked on $(basename "$ctrl")."
done

# --- 2) Install a udev rule to keep removable storage blocked across replugs -
if [ -z "${IT_DRYRUN:-}" ]; then
    cat > "$UDEV_RULE" <<'EOF'
# IT-Tool 647 emergency USB lock. Removed by 648.
# Refuse newly attached USB devices, except Bluetooth (bInterfaceClass e0).
ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{bDeviceClass}!="e0", ATTR{authorized}="0"
EOF
    it_run udevadm control --reload-rules 2>/dev/null
    it_ok "udev lock rule installed and reloaded."
else
    printf '  %s[DRYRUN]%s would write %s\n' "$C_YL" "$C_RS" "$UDEV_RULE"
fi

# --- 3) De-authorise currently connected USB devices (skip Bluetooth + hubs) -
disabled=0
for d in /sys/bus/usb/devices/*; do
    [ -w "$d/authorized" ] || continue
    # Skip root hubs (usbN) and hub-class devices so the tree survives.
    case "$(basename "$d")" in usb[0-9]*) continue ;; esac
    dclass=$(cat "$d/bDeviceClass" 2>/dev/null)
    iclass=$(cat "$d/*/bInterfaceClass" 2>/dev/null | head -1)
    [ "$dclass" = "09" ] && continue            # hub
    [ "$dclass" = "e0" ] && continue            # wireless / bluetooth
    prev=$(cat "$d/authorized" 2>/dev/null)
    [ -z "${IT_DRYRUN:-}" ] && echo "auth $d $prev" >> "$STATE_FILE"
    it_run bash -c "echo 0 > '$d/authorized'" && disabled=$((disabled+1))
done
it_ok "De-authorised $disabled connected USB device(s)."

# --- 4) Also blacklist usb-storage so drives cannot mount ------------------
if [ -z "${IT_DRYRUN:-}" ]; then
    echo "install usb_storage /bin/true" > /etc/modprobe.d/99-ittool-usb-storage.conf
    modprobe -r usb_storage 2>/dev/null
    it_ok "usb-storage module blocked."
fi

if [ "$disabled" -eq 0 ] && [ ! -w /sys/bus/usb/devices/usb1/authorized_default ]; then
    it_warn "sysfs USB controls are not writable here (container/limited host)."
    it_note "On a real host this de-authorises every USB port immediately."
fi

it_ok "USB LOCK ACTIVE. Connect over Bluetooth and run 648.Emergency_Unlock_usb.sh to restore."
it_pause
