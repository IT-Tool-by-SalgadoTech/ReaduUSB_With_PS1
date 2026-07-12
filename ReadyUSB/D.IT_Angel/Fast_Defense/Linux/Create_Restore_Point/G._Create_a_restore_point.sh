#!/usr/bin/env bash
# ScriptID: ST-LIN-0645  |  645.G._Create_a_restore_point.sh
# Creates a restore point: a tar archive of /etc plus the installed-package list,
# honouring the FREQ_MINUTES restriction. Native snapshot is used when available.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

RP_DIR=/var/backups/ittool_restore
RP_CFG="$RP_DIR/config"
LABEL="ReadyUSB_RestorePoint"

it_banner "645.G._Create_a_restore_point.sh" "ST-LIN-0645" "Creates a system restore point (tar of /etc + package list; native snapshot if available)"
it_need_root "$@"

it_run mkdir -p "$RP_DIR"; it_run chmod 700 "$RP_DIR" 2>/dev/null

# --- Frequency restriction check (mirrors Windows 24h limiter) --------------
freq=1440
[ -f "$RP_CFG" ] && freq=$(grep '^FREQ_MINUTES=' "$RP_CFG" 2>/dev/null | cut -d= -f2)
freq=${freq:-1440}
if [ "$freq" -gt 0 ] 2>/dev/null; then
    newest=$(ls -dt "$RP_DIR"/rp_* 2>/dev/null | head -1)
    if [ -n "$newest" ]; then
        age=$(( ( $(date +%s) - $(stat -c %Y "$newest" 2>/dev/null || echo 0) ) / 60 ))
        if [ "$age" -lt "$freq" ]; then
            it_warn "A restore point was created $age minute(s) ago; the limit is $freq minute(s)."
            it_note "Run 642.D._RestoreFreqUnlock.sh to remove the restriction, then retry."
            it_pause; exit 0
        fi
    fi
fi

stamp=$(date +%Y%m%d_%H%M%S)
dest="$RP_DIR/rp_${stamp}_${LABEL}"
it_info "Creating restore point '$LABEL'..."
it_run mkdir -p "$dest"

if [ -n "${IT_DRYRUN:-}" ]; then
    printf '  %s[DRYRUN]%s would archive /etc and package list into %s\n' "$C_YL" "$C_RS" "$dest"
    it_ok "Restore point (dry-run) prepared."
    it_pause; exit 0
fi

# 1) Archive /etc (the bulk of recoverable system configuration).
if tar czf "$dest/etc.tar.gz" -C / etc 2>/dev/null; then
    it_ok "Archived /etc -> $dest/etc.tar.gz"
else
    it_warn "Some /etc files could not be archived (continuing)."
fi

# 2) Save the installed-package list for this distro.
case "$IT_FAMILY" in
    debian) dpkg --get-selections > "$dest/packages.list" 2>/dev/null ;;
    rhel)   rpm -qa | sort         > "$dest/packages.list" 2>/dev/null ;;
    arch)   pacman -Qqe            > "$dest/packages.list" 2>/dev/null ;;
    *)      : ;;
esac
[ -s "$dest/packages.list" ] && it_ok "Saved installed-package list ($(wc -l < "$dest/packages.list") entries)."

# 3) Metadata.
{
    echo "label=$LABEL"
    echo "created=$(date -Iseconds)"
    echo "distro=$IT_DISTRO_PRETTY"
    echo "kernel=$(uname -r)"
} > "$dest/metadata.txt"

# 4) Native snapshot as a bonus if a backend is present.
if command -v snapper >/dev/null 2>&1 && snapper list >/dev/null 2>&1; then
    snapper create -d "$LABEL $stamp" >/dev/null 2>&1 && it_ok "btrfs/snapper snapshot also created."
fi

it_ok "Restore point created successfully: $dest"
it_note "Recover config later with:  tar xzf $dest/etc.tar.gz -C /"
it_pause
