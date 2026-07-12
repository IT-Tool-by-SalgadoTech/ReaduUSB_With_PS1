#!/usr/bin/env bash
# ScriptID: ST-LIN-0641  |  641.C._Check_protection_status_on_all_units.sh
# Shows restore-point protection status and lists existing restore points/snapshots.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

RP_DIR=/var/backups/ittool_restore
RP_CFG="$RP_DIR/config"

it_banner "641.C._Check_protection_status_on_all_units.sh" "ST-LIN-0641" "Checks restore-point protection status and lists existing restore points"
it_want_root

if [ -f "$RP_CFG" ]; then
    it_ok "System Protection is ENABLED."
    it_info "Configuration:"; sed 's/^/    /' "$RP_CFG"
else
    it_warn "System Protection is NOT enabled. Run 639 first."
fi

echo
it_info "IT-Tool restore points in $RP_DIR:"
if [ -d "$RP_DIR" ] && ls -d "$RP_DIR"/rp_* >/dev/null 2>&1; then
    for d in "$RP_DIR"/rp_*; do
        [ -d "$d" ] || continue
        size=$(du -sh "$d" 2>/dev/null | awk '{print $1}')
        printf '    %-40s  %s\n' "$(basename "$d")" "${size:-?}"
    done
else
    it_note "  (no restore points created yet - use 645)"
fi

# Also surface native snapshots if a backend exists.
if command -v snapper >/dev/null 2>&1; then
    echo; it_info "btrfs/snapper snapshots:"; snapper list 2>/dev/null | sed 's/^/    /' | head -20
fi
if command -v lvs >/dev/null 2>&1 && lvs >/dev/null 2>&1; then
    echo; it_info "LVM snapshots:"; lvs -o lv_name,origin,lv_size 2>/dev/null | grep -v ' *$' | sed 's/^/    /'
fi

it_pause
