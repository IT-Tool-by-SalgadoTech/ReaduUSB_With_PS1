#!/usr/bin/env bash
# ScriptID: ST-LIN-0646  |  646.Check_USB_Status.sh
# Reports whether USB mass-storage is enabled or blocked on this system.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "646.Check_USB_Status.sh" "ST-LIN-0646" "Reports whether USB mass-storage devices are enabled or blocked"
it_want_root

it_info "Checking USB storage status..."
blocked=0

# 1) modprobe blacklist / install-false for usb-storage.
if grep -rqsE '^(blacklist|install)[[:space:]]+usb.?storage' /etc/modprobe.d /usr/lib/modprobe.d 2>/dev/null; then
    it_warn "usb-storage is blacklisted in modprobe config."
    grep -rsE 'usb.?storage' /etc/modprobe.d 2>/dev/null | sed 's/^/      /'
    blocked=1
fi

# 2) Is the module currently loaded?
if lsmod 2>/dev/null | grep -q '^usb_storage'; then
    it_note "Kernel module 'usb_storage' is currently loaded."
else
    it_note "Kernel module 'usb_storage' is NOT loaded."
    [ "$blocked" -eq 0 ] && it_note "(it usually loads on demand when a USB drive is inserted)"
fi

# 3) New-device authorization default (0 = new USB devices are refused).
def=/sys/bus/usb/devices/usb1/authorized_default
if [ -r "$def" ]; then
    val=$(cat "$def" 2>/dev/null)
    if [ "$val" = "0" ]; then it_warn "New USB devices are being REFUSED (authorized_default=0)."; blocked=1
    else it_note "New USB devices are accepted (authorized_default=$val)."; fi
fi

# 4) Removable-storage udev deny rule left by the lock script.
if [ -f /etc/udev/rules.d/99-ittool-usb-lock.rules ]; then
    it_warn "IT-Tool USB lock udev rule is present (627 lock active)."
    blocked=1
fi

echo
if [ "$blocked" -eq 1 ]; then
    it_err "Status: BLOCKED - USB storage is restricted on this system."
else
    it_ok  "Status: ENABLED - USB storage devices are allowed."
fi

it_pause
