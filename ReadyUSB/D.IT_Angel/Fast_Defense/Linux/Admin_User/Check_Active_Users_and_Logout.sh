#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Check_Active_Users_and_Logout.sh
# Lists active user sessions and logs off a selected session.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
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
echo "${C_CY}  Script: Check_Active_Users_and_Logout.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Admin & Security${C_RS}"
echo "${C_CY}  Description: Lists active user sessions and logs off a selected session${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

use_loginctl=0
if command -v loginctl >/dev/null 2>&1 && loginctl list-sessions >/dev/null 2>&1; then
    use_loginctl=1
fi

it_info "Current logged-on sessions:"
if [ "$use_loginctl" -eq 1 ]; then
    loginctl list-sessions 2>/dev/null | sed 's/^/    /'
else
    it_note "(systemd-logind not available; using 'who')"
    who 2>/dev/null | sed 's/^/    /' || it_note "  (no sessions reported)"
fi
echo

if [ "$use_loginctl" -eq 1 ]; then
    sid=$(it_ask "  Enter the Session ID to log off (blank to skip): " "")
    [ -z "$sid" ] && { it_note "No session selected."; it_pause; exit 0; }
    if it_run loginctl terminate-session "$sid"; then
        it_ok "Session '$sid' logged off."
    else
        it_err "Failed to terminate session '$sid'."
    fi
else
    tuser=$(it_ask "  Enter a USERNAME to log off all its sessions (blank to skip): " "")
    [ -z "$tuser" ] && { it_note "No user selected."; it_pause; exit 0; }
    if it_run pkill -KILL -u "$tuser"; then
        it_ok "All processes/sessions for '$tuser' terminated."
    else
        it_warn "No processes found for '$tuser' (or termination failed)."
    fi
fi

it_pause
