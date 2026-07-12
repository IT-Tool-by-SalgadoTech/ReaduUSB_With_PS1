#!/usr/bin/env bash
# ScriptID: ST-LIN-0662  |  665.Restart_AV_Service.sh
# Linux analog of "Restart Defender": ensures the antivirus service (ClamAV) is running
# and its on-access / freshclam updater is active.
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
echo "${C_CY}  Script: 662.Restart_AV_Service.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0662${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Admin & Security${C_RS}"
echo "${C_CY}  Description: Ensures the antivirus service (ClamAV daemon + freshclam) is running${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

# Candidate AV units across distros.
AV_UNITS="clamav-daemon clamd@scan clamd freshclam clamav-freshclam clamonacc"
found=0

if ! it_have_systemd; then
    it_warn "systemd is not active here; cannot manage AV services."
    it_note "On a real host this ensures ClamAV (clamav-daemon/clamd) and freshclam are running."
    it_pause; exit 0
fi

for u in $AV_UNITS; do
    if it_service_exists "$u"; then
        found=1
        it_service_enable "$u"
        if it_service_restart "$u"; then
            it_ok "Service '$u' (re)started."
        else
            it_warn "Could not start '$u'."
        fi
    fi
done

if [ "$found" -eq 0 ]; then
    it_warn "No antivirus service (ClamAV) is installed on this system."
    ans=$(it_ask "  Install ClamAV now? Type YES: " "")
    if [ "$ans" = "YES" ]; then
        it_install clamdscan clamav-daemon clamd clamav \
            && { it_service_enable clamav-daemon; it_service_start clamav-daemon; it_ok "ClamAV installed and started."; } \
            || it_err "ClamAV installation failed."
    fi
else
    echo
    it_info "Current AV status:"
    for u in $AV_UNITS; do
        it_service_exists "$u" && printf '    %-22s : %s\n' "$u" "$(systemctl is-active "$u" 2>/dev/null)"
    done
fi

it_pause
