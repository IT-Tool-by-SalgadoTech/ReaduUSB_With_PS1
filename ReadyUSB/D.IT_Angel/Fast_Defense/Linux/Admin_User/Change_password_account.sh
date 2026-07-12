#!/usr/bin/env bash
# ScriptID: ST-LIN-0635  |  635.Change_password_account.sh
# Changes a local user account password interactively.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "635.Change_password_account.sh" "ST-LIN-0635" "Changes a local user account password interactively"
it_need_root "$@"

user=$(it_ask "Enter user: " "")
if [ -z "$user" ]; then it_err "No user provided."; it_pause; exit 1; fi
if ! id "$user" >/dev/null 2>&1; then it_err "User '$user' does not exist."; it_pause; exit 1; fi

it_info "Setting a new password for '$user' (you will be prompted twice)..."
if it_run passwd "$user"; then
    it_ok "Password for '$user' updated."
else
    it_err "Failed to change the password for '$user'."
fi

it_pause
