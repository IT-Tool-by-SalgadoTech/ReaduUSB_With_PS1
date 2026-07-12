#!/usr/bin/env bash
# ScriptID: ST-LIN-0639  |  643.E._CheckRestoreFreq.sh
# Shows the current restore-point minimum-interval setting.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

RP_CFG=/var/backups/ittool_restore/config

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
echo "${C_CY}  Script: 639.E._CheckRestoreFreq.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0639${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Restore Point${C_RS}"
echo "${C_CY}  Description: Shows the current restore-point creation frequency restriction${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_want_root

if [ -f "$RP_CFG" ]; then
    freq=$(grep '^FREQ_MINUTES=' "$RP_CFG" 2>/dev/null | cut -d= -f2)
    freq=${freq:-unset}
    it_info "FREQ_MINUTES = $freq"
    case "$freq" in
        0)   it_note "No restriction: a restore point can be created at any time." ;;
        1440) it_note "Default restriction: minimum 1440 minutes (24 hours) between restore points." ;;
        *)   it_note "Minimum interval: $freq minute(s) between restore points." ;;
    esac
else
    it_warn "System Protection is not configured. Run 639 first."
fi

it_pause
