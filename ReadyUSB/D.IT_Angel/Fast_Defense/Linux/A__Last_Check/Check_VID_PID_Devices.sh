#!/usr/bin/env bash
# ScriptID: ST-LIN-0628  |  628.Check_VID_PID_Devices.sh
# Lists all present USB devices that expose a VID and PID.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "628.Check_VID_PID_Devices.sh" "ST-LIN-0628" "Lists all present USB devices that expose a VID and PID"

if ! command -v lsusb >/dev/null 2>&1; then
    it_install lsusb usbutils usbutils usbutils >/dev/null 2>&1
fi
if ! command -v lsusb >/dev/null 2>&1; then
    it_warn "lsusb (usbutils) is not available; falling back to sysfs."
    found=0
    printf '    %-9s %-9s %s\n' "VID" "PID" "NAME"
    for d in /sys/bus/usb/devices/*; do
        [ -r "$d/idVendor" ] || continue
        vid=$(cat "$d/idVendor" 2>/dev/null); pid=$(cat "$d/idProduct" 2>/dev/null)
        name=$(cat "$d/product" 2>/dev/null || echo "USB Device")
        printf '    %-9s %-9s %s\n' "$vid" "$pid" "$name"; found=1
    done
    [ "$found" -eq 0 ] && it_warn "No USB devices with VID/PID found." || it_ok "Devices listed."
    it_pause; exit 0
fi

found=0
printf '    %-9s %-9s %s\n' "VID" "PID" "NAME"
printf '    %s\n' "--------------------------------------------------------"
while read -r line; do
    idpair=$(printf '%s' "$line" | grep -oE 'ID [0-9a-fA-F]{4}:[0-9a-fA-F]{4}' | awk '{print $2}')
    [ -z "$idpair" ] && continue
    vid="${idpair%%:*}"; pid="${idpair##*:}"
    name=$(printf '%s' "$line" | sed -E 's/.*ID [0-9a-fA-F]{4}:[0-9a-fA-F]{4} //')
    printf '    %-9s %-9s %s\n' "$vid" "$pid" "$name"; found=1
done < <(lsusb 2>/dev/null)

[ "$found" -eq 1 ] && it_ok "USB devices with VID/PID listed above." \
                   || it_warn "No USB devices with VID/PID found."
it_pause
