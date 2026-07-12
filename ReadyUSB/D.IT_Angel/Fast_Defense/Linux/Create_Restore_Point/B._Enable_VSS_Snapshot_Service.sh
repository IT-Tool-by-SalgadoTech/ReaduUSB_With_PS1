#!/usr/bin/env bash
# ScriptID: ST-LIN-0640  |  640.B._Enable_VSS_Snapshot_Service.sh
# Linux analog of "Enable VSS": activates the snapshot backend (btrfs/snapper or LVM),
# or confirms the portable tar-based fallback is ready.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

RP_DIR=/var/backups/ittool_restore

it_banner "640.B._Enable_VSS_Snapshot_Service.sh" "ST-LIN-0640" "Activates the snapshot backend (btrfs/snapper, LVM) or confirms the tar fallback"
it_need_root "$@"

fstype=$(findmnt -no FSTYPE / 2>/dev/null || stat -f -c %T / 2>/dev/null)
it_info "Root filesystem: ${fstype:-unknown}"

case "$fstype" in
    btrfs)
        if command -v snapper >/dev/null 2>&1; then
            it_service_enable snapper-timeline.timer 2>/dev/null
            it_service_start  snapper-timeline.timer 2>/dev/null
            it_ok "snapper present - btrfs timeline snapshots enabled."
        else
            it_note "btrfs detected but 'snapper' not installed."
            ans=$(it_ask "  Install snapper now? Type YES: " "")
            [ "$ans" = "YES" ] && { it_install snapper snapper snapper snapper && it_ok "snapper installed." || it_warn "snapper install failed."; }
        fi
        ;;
    *)
        if command -v lvs >/dev/null 2>&1 && lvs >/dev/null 2>&1; then
            it_ok "LVM detected - LVM snapshots can back the restore points."
        else
            it_note "No btrfs/LVM snapshot backend; the portable tar-based restore point is used."
        fi
        ;;
esac

# The 'service' being ready here means the store exists and is writable.
if it_run mkdir -p "$RP_DIR" && { [ -w "$RP_DIR" ] || [ -n "${IT_DRYRUN:-}" ]; }; then
    it_ok "Snapshot/restore store is active and writable at $RP_DIR."
else
    it_err "Restore store is not writable."; it_pause; exit 1
fi

it_pause
