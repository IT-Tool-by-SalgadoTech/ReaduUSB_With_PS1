#!/usr/bin/env bash
# ScriptID: ST-LIN-0646  |  650.BIOS.sh
# Reboots the machine into the UEFI firmware setup or into rescue mode.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

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
echo "${C_CY}  Script: 646.BIOS.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0646${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Admin & Security${C_RS}"
echo "${C_CY}  Description: Reboot into UEFI firmware setup or Linux rescue (single-user) mode${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
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
