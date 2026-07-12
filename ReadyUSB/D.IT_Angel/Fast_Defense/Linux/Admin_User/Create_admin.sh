#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Create_admin.sh
# Creates a new local user and grants it administrative rights (sudo/wheel group).
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
echo "${C_CY}  Script: Create_admin.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Admin & Security${C_RS}"
echo "${C_CY}  Description: Creates a new local user and adds it to the admin group (sudo/wheel)${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

# Pick the correct admin group for this distro.
admgrp=""
if getent group sudo  >/dev/null 2>&1; then admgrp=sudo
elif getent group wheel >/dev/null 2>&1; then admgrp=wheel
fi
case "$IT_FAMILY" in
    rhel|arch) getent group wheel >/dev/null 2>&1 && admgrp=wheel ;;
esac

user=$(it_ask "Enter username: " "")
if [ -z "$user" ]; then it_err "No username provided."; it_pause; exit 1; fi
if id "$user" >/dev/null 2>&1; then it_err "User '$user' already exists."; it_pause; exit 1; fi
pass=$(it_ask "Enter password: " "")

if it_run useradd -m -s /bin/bash "$user"; then
    it_ok "User '$user' created with a home directory."
else
    it_err "Failed to create user '$user'."; it_pause; exit 1
fi

if [ -n "$pass" ]; then
    if [ -n "${IT_DRYRUN:-}" ]; then
        printf '  %s[DRYRUN]%s set password for %s\n' "$C_YL" "$C_RS" "$user"
    else
        printf '%s:%s' "$user" "$pass" | chpasswd 2>/dev/null && it_ok "Password set." || it_warn "Could not set password."
    fi
else
    it_note "No password given - use 635 later, or the account stays locked."
fi

if [ -n "$admgrp" ]; then
    it_run usermod -aG "$admgrp" "$user" && it_ok "'$user' added to the '$admgrp' group (administrator)."
else
    it_warn "No sudo/wheel group found; user created without admin rights."
fi

it_pause
