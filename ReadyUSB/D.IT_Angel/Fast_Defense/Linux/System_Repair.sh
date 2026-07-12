#!/usr/bin/env bash
# ScriptID: ST-LIN-0668  |  670.System_Repair.sh
# Linux analog of SFC/DISM: verifies and repairs installed packages and system files
# using the distro's package manager, and schedules a filesystem check.
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
echo "${C_CY}  Script: 668.System_Repair.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0668${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Admin & Security${C_RS}"
echo "${C_CY}  Description: Verifies/repairs system packages and files (package-manager equivalent of SFC/DISM)${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

it_info "Detected package family: $IT_FAMILY"
echo

case "$IT_FAMILY" in
    debian)
        it_info "Checking package integrity (debsums) and fixing broken packages..."
        it_install debsums debsums debsums debsums >/dev/null 2>&1
        if command -v debsums >/dev/null 2>&1; then
            bad=$(debsums -s 2>/dev/null)
            [ -n "$bad" ] && { it_warn "Files failing checksum:"; printf '%s\n' "$bad" | sed 's/^/    /'; } \
                          || it_ok "debsums: all checked files match their package checksums."
        fi
        it_run apt-get update >/dev/null 2>&1
        it_run apt-get -f install -y >/dev/null 2>&1 && it_ok "apt: broken dependencies repaired."
        it_run dpkg --configure -a >/dev/null 2>&1 && it_ok "dpkg: pending package configuration completed."
        ;;
    rhel)
        it_info "Verifying packages (rpm -Va) and refreshing metadata..."
        changed=$(rpm -Va 2>/dev/null | grep -vE '^\.{8}|missing' | head -30)
        [ -n "$changed" ] && { it_warn "Modified package files (top 30):"; printf '%s\n' "$changed" | sed 's/^/    /'; } \
                          || it_ok "rpm -Va: no unexpected package file changes."
        it_run "${IT_PKG:-dnf}" -y check >/dev/null 2>&1 && it_ok "$IT_PKG: dependency check passed."
        ;;
    arch)
        it_info "Checking packages (pacman -Qkk) and refreshing databases..."
        it_run pacman -Syy >/dev/null 2>&1 && it_ok "pacman: databases refreshed."
        bad=$(pacman -Qkk 2>/dev/null | grep -vE '0 altered files|, 0 ' | head -30)
        [ -n "$bad" ] && { it_warn "Packages with altered files (top 30):"; printf '%s\n' "$bad" | sed 's/^/    /'; } \
                      || it_ok "pacman -Qkk: package files are intact."
        ;;
    *)
        it_warn "Unknown package family; skipping package verification."
        ;;
esac

# Schedule a filesystem check on next boot (safe, non-destructive request).
echo
if it_have_systemd; then
    if it_run touch /forcefsck 2>/dev/null; then
        it_ok "Filesystem check scheduled for next boot (/forcefsck)."
    else
        it_note "Could not schedule a boot-time fsck (read-only root?)."
    fi
fi

it_warn "Repair pass finished. A reboot is recommended if system files were changed."
it_pause
