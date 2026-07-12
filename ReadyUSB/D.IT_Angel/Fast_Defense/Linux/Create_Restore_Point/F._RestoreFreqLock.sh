#!/usr/bin/env bash
# ScriptID: ST-LIN-0644  |  644.F._RestoreFreqLock.sh
# Restores the 24-hour minimum interval for creating restore points.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

RP_DIR=/var/backups/ittool_restore
RP_CFG="$RP_DIR/config"

it_banner "644.F._RestoreFreqLock.sh" "ST-LIN-0644" "Restores the 24-hour restore-point creation restriction (FREQ_MINUTES=1440)"
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
