#!/usr/bin/env bash
# ScriptID: ST-LIN-0664  |  667.Restore_Service_Defaults.sh
# Linux analog of restoring a tampered service registry key: un-masks a service,
# restores its vendor preset, reloads systemd and clears failed state.
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
echo "${C_CY}  Script: 664.Restore_Service_Defaults.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0664${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Admin & Security${C_RS}"
echo "${C_CY}  Description: Un-masks a service, restores its vendor preset, reloads systemd and clears failed units${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

if ! it_have_systemd; then
    it_warn "systemd is not active here; nothing to restore."
    it_note "On a real host this reverses service masking/tampering (systemctl unmask + preset + daemon-reload)."
    it_pause; exit 0
fi

svc=$(it_ask "Enter a service to restore to defaults (blank = just reload+clean systemd): " "")

it_info "Reloading the systemd manager configuration..."
it_run systemctl daemon-reload && it_ok "systemd daemon reloaded."

it_info "Clearing failed unit state..."
it_run systemctl reset-failed >/dev/null 2>&1 && it_ok "Failed units reset."

if [ -n "$svc" ]; then
    svc="${svc%.service}"
    if systemctl list-unit-files "${svc}.service" >/dev/null 2>&1; then
        it_run systemctl unmask "$svc" >/dev/null 2>&1 && it_ok "'$svc' un-masked."
        # Restore the distro's on/off default for the unit.
        it_run systemctl preset "$svc" >/dev/null 2>&1 && it_ok "'$svc' reset to its vendor preset (enabled/disabled default)."
        it_run systemctl restart "$svc" >/dev/null 2>&1 && it_ok "'$svc' restarted." \
            || it_warn "'$svc' could not be restarted (check its config)."
        echo
        it_info "State of '$svc':"
        printf '    enabled : %s\n    active  : %s\n' \
            "$(systemctl is-enabled "$svc" 2>/dev/null)" "$(systemctl is-active "$svc" 2>/dev/null)"
    else
        it_err "Service '$svc' is not known to systemd on this host."
    fi
fi

it_warn "A reboot is recommended if a core service was tampered with."
it_pause
