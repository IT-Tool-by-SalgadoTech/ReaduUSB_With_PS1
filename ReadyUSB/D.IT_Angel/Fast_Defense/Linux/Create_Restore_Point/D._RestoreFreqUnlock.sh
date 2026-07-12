#!/usr/bin/env bash
# ScriptID: ST-LIN-0642  |  642.D._RestoreFreqUnlock.sh
# Removes the minimum-interval restriction so restore points can be created any time.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

RP_DIR=/var/backups/ittool_restore
RP_CFG="$RP_DIR/config"

it_banner "642.D._RestoreFreqUnlock.sh" "ST-LIN-0642" "Removes the 24h restriction for creating restore points (FREQ_MINUTES=0)"
it_need_root "$@"

it_run mkdir -p "$RP_DIR"
if [ -n "${IT_DRYRUN:-}" ]; then
    printf '  %s[DRYRUN]%s set FREQ_MINUTES=0 in %s\n' "$C_YL" "$C_RS" "$RP_CFG"
else
    [ -f "$RP_CFG" ] || printf 'ENABLED=1\nFREQ_MINUTES=1440\n' > "$RP_CFG"
    if grep -q '^FREQ_MINUTES=' "$RP_CFG"; then
        sed -i 's/^FREQ_MINUTES=.*/FREQ_MINUTES=0/' "$RP_CFG"
    else
        echo 'FREQ_MINUTES=0' >> "$RP_CFG"
    fi
    it_ok "Restriction removed. Restore points can now be created at any time."
fi

it_pause
