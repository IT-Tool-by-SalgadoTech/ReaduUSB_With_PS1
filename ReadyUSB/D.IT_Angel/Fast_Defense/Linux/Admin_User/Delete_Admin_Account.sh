#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Delete_Admin_Account.sh
# Deletes a local user account from the system.
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
echo "${C_CY}  Script: Delete_Admin_Account.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Admin & Security${C_RS}"
echo "${C_CY}  Description: Deletes a local user account from the system${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

user=$(it_ask "Enter the username to delete: " "")
if [ -z "$user" ]; then it_err "No username provided."; it_pause; exit 1; fi
if ! id "$user" >/dev/null 2>&1; then it_err "User '$user' does not exist."; it_pause; exit 1; fi

# Guardrails: never delete root or the invoking (SUDO) user.
if [ "$user" = "root" ]; then it_err "Refusing to delete 'root'."; it_pause; exit 1; fi
if [ "$user" = "${SUDO_USER:-}" ]; then it_err "Refusing to delete the account you are logged in as ('$user')."; it_pause; exit 1; fi

rmhome=$(it_ask "  Also remove the home directory and mail spool? (yes/no): " "no")

it_warn "About to delete user '$user'."
go=$(it_ask "  Type the username again to confirm: " "")
[ "$go" != "$user" ] && { it_warn "Confirmation mismatch. Nothing changed."; it_pause; exit 0; }

# Kill any live processes first so userdel does not fail on 'currently used'.
pkill -KILL -u "$user" 2>/dev/null; sleep 1

if [ "$rmhome" = "yes" ] || [ "$rmhome" = "y" ] || [ "$rmhome" = "YES" ]; then
    it_run userdel -r "$user" && it_ok "User '$user' and its home directory deleted." \
        || it_err "Failed to delete '$user'."
else
    it_run userdel "$user" && it_ok "User '$user' deleted (home directory kept)." \
        || it_err "Failed to delete '$user'."
fi

it_pause
