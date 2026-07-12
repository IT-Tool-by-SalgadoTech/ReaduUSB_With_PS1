#!/usr/bin/env bash
# ScriptID: ST-LIN-0643  |  643.E._CheckRestoreFreq.sh
# Shows the current restore-point minimum-interval setting.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

RP_CFG=/var/backups/ittool_restore/config

it_banner "643.E._CheckRestoreFreq.sh" "ST-LIN-0643" "Shows the current restore-point creation frequency restriction"
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
