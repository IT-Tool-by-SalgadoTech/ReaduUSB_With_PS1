#!/usr/bin/env bash
# ScriptID: ST-LIN-0635  |  639.A._Enable_SystemProtection.sh
# Linux analog of "Enable System Protection": prepares the restore-point store.
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
echo "${C_CY}  Script: 635.A._Enable_SystemProtection.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0635${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Restore Point${C_RS}"
echo "${C_CY}  Description: Enables IT-Tool system protection (creates the restore-point store)${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

it_info "Enabling System Protection (restore-point store at $RP_DIR)..."
if it_run mkdir -p "$RP_DIR"; then
    it_run chmod 700 "$RP_DIR"
    if [ ! -f "$RP_CFG" ] && [ -z "${IT_DRYRUN:-}" ]; then
        {
            echo "# IT-Tool restore-point configuration"
            echo "ENABLED=1"
            echo "FREQ_MINUTES=1440"   # mirrors Windows' 24h default restriction
        } > "$RP_CFG"
    elif [ -f "$RP_CFG" ] && [ -z "${IT_DRYRUN:-}" ]; then
        sed -i 's/^ENABLED=.*/ENABLED=1/' "$RP_CFG" 2>/dev/null
    fi
    it_ok "System Protection enabled. Restore points will be stored under $RP_DIR."
else
    it_err "Could not create the restore-point store."; it_pause; exit 1
fi

# Report the snapshot capability of the root filesystem.
fstype=$(findmnt -no FSTYPE / 2>/dev/null || stat -f -c %T / 2>/dev/null)
it_note "Root filesystem type: ${fstype:-unknown}"
case "$fstype" in
    btrfs) it_ok "btrfs detected - native snapshots available (see 640)." ;;
    *)     it_note "No native snapshotting; IT-Tool uses tar-based restore points (portable)." ;;
esac

it_pause
