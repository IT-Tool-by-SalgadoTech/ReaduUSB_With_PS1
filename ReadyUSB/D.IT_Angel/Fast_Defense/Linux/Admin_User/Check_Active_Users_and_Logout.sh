#!/usr/bin/env bash
# ScriptID: ST-LIN-0636  |  636.Check_Active_Users_and_Logout.sh
# Lists active user sessions and logs off a selected session.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "636.Check_Active_Users_and_Logout.sh" "ST-LIN-0636" "Lists active user sessions and logs off a selected session"
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
