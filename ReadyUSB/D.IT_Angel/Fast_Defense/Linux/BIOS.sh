#!/usr/bin/env bash
# ScriptID: ST-LIN-0650  |  650.BIOS.sh
# Reboots the machine into the UEFI firmware setup or into rescue mode.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "650.BIOS.sh" "ST-LIN-0650" "Reboot into UEFI firmware setup or Linux rescue (single-user) mode"
it_need_root "$@"

if [ ! -d /sys/firmware/efi ]; then
    it_warn "This machine booted in legacy BIOS mode (no EFI). 'Reboot to firmware' needs UEFI."
    it_note "You can still use option 2 (rescue mode)."
fi

echo "  1) Reboot to UEFI firmware setup"
echo "  2) Reboot into rescue (single-user) mode"
echo
opt=$(it_ask "  Enter option (1 or 2): " "")

case "$opt" in
    1)
        it_warn "Rebooting into UEFI firmware setup..."
        if it_have_systemd; then
            it_run systemctl reboot --firmware-setup
        else
            it_err "systemd is required to request the firmware setup on reboot."
            it_note "Reboot manually and press your board's BIOS key (Del/F2/F10)."
        fi
        ;;
    2)
        it_warn "Switching to rescue (single-user) mode..."
        if it_have_systemd; then
            it_run systemctl rescue
        else
            it_err "systemd not active; cannot switch to rescue.target here."
            it_note "Add 'systemd.unit=rescue.target' to the kernel cmdline at boot instead."
        fi
        ;;
    *)
        it_err "Invalid option. Run again and choose 1 or 2."
        ;;
esac

it_pause
