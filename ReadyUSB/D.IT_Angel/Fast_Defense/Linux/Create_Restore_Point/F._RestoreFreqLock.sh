#!/usr/bin/env bash
# ScriptID: ST-LIN  |  F._RestoreFreqLock.sh
# Restores the 24-hour minimum interval for creating restore points.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

RP_DIR=/var/backups/ittool_restore
RP_CFG="$RP_DIR/config"

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
echo "${C_CY}  Script: F._RestoreFreqLock.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Restore Point${C_RS}"
echo "${C_CY}  Description: Restores the 24-hour restore-point creation restriction (FREQ_MINUTES=1440)${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

it_run mkdir -p "$RP_DIR"
if [ -n "${IT_DRYRUN:-}" ]; then
    printf '  %s[DRYRUN]%s set FREQ_MINUTES=1440 in %s\n' "$C_YL" "$C_RS" "$RP_CFG"
else
    [ -f "$RP_CFG" ] || printf 'ENABLED=1\n' > "$RP_CFG"
    if grep -q '^FREQ_MINUTES=' "$RP_CFG"; then
        sed -i 's/^FREQ_MINUTES=.*/FREQ_MINUTES=1440/' "$RP_CFG"
    else
        echo 'FREQ_MINUTES=1440' >> "$RP_CFG"
    fi
    it_ok "Restriction restored. Minimum interval is now 1440 minutes (24 hours)."
fi

it_pause
