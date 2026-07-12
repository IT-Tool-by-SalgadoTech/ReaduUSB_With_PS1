#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Check_HID_Devices.sh
# Lists present HID keyboard/mouse devices with their VID and PID.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
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
echo "${C_CY}  Script: Check_HID_Devices.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Hardware${C_RS}"
echo "${C_CY}  Description: Lists present HID keyboard and mouse devices with their VID and PID${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
found=0
printf '    %-9s %-9s %-10s %s\n' "VID" "PID" "CLASS" "NAME"
printf '    %s\n' "----------------------------------------------------------------"

# Preferred source: lsusb (Human Interface Device / keyboard / mouse).
if command -v lsusb >/dev/null 2>&1; then
    while read -r line; do
        idpair=$(printf '%s' "$line" | grep -oE 'ID [0-9a-fA-F]{4}:[0-9a-fA-F]{4}' | awk '{print $2}')
        [ -z "$idpair" ] && continue
        vid="${idpair%%:*}"; pid="${idpair##*:}"
        name=$(printf '%s' "$line" | sed -E 's/.*ID [0-9a-fA-F]{4}:[0-9a-fA-F]{4} //')
        low=$(printf '%s' "$name" | tr 'A-Z' 'a-z')
        # Query the verbose descriptor for a HID interface when possible.
        cls=""
        case "$low" in
            *keyboard*|*teclado*) cls="Keyboard" ;;
            *mouse*|*rat*)        cls="Mouse" ;;
            *)
                if lsusb -v -d "$idpair" 2>/dev/null | grep -qi 'bInterfaceClass.*3 Human Interface Device'; then
                    cls="HID"
                fi ;;
        esac
        [ -z "$cls" ] && continue
        printf '    %-9s %-9s %-10s %s\n' "$vid" "$pid" "$cls" "$name"
        found=1
    done < <(lsusb 2>/dev/null)
fi

# Secondary source: kernel input devices (covers PS/2 and internal keyboards).
if [ -r /proc/bus/input/devices ]; then
    awk '
        /^N: Name=/ { name=$0; sub(/^N: Name="/,"",name); sub(/"$/,"",name) }
        /^I: / { vid=""; pid=""; for(i=1;i<=NF;i++){ if($i ~ /^Vendor=/){vid=substr($i,8)}; if($i ~ /^Product=/){pid=substr($i,9)} } }
        /^H: Handlers=/ {
            if ($0 ~ /kbd/)   { printf "    %-9s %-9s %-10s %s\n", vid, pid, "Keyboard", name }
            else if ($0 ~ /mouse/) { printf "    %-9s %-9s %-10s %s\n", vid, pid, "Mouse", name }
        }
    ' /proc/bus/input/devices && found=1
fi

if [ "$found" -eq 1 ]; then
    it_ok "HID keyboard/mouse devices listed above."
else
    it_warn "No HID keyboard or mouse devices found."
fi

it_pause
