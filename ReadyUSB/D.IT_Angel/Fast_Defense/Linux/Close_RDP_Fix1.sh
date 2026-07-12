#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Close_RDP_Fix1.sh
# Disables Remote Desktop by stopping and disabling the RDP servers (xrdp / gnome-remote-desktop).
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
echo "${C_CY}  Script: Close_RDP_Fix1.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Remote Desktop${C_RS}"
echo "${C_CY}  Description: Disables Remote Desktop (RDP) by stopping and disabling the xrdp/GNOME RDP services${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

found=0
for svc in xrdp xrdp-sesman gnome-remote-desktop; do
    if it_service_exists "$svc"; then
        found=1
        it_service_stop "$svc"
        it_service_disable "$svc"
        it_ok "Service '$svc' stopped and disabled."
    fi
done

if [ "$found" -eq 0 ]; then
    if ! it_have_systemd; then
        it_warn "systemd is not active here; cannot query RDP services."
    else
        it_ok "No RDP server (xrdp / gnome-remote-desktop) is installed. RDP is already off."
    fi
fi

# Report whether anything is still listening on 3389.
if ss -H -lnt 2>/dev/null | grep -q ':3389'; then
    it_warn "Something is STILL listening on TCP 3389 - use 656.Close_RDP_Fix2.sh to block the port."
else
    it_ok "Nothing is listening on TCP 3389."
fi

it_pause
