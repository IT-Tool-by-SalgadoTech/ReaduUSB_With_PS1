#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Sudo_Password_On.sh
# Linux analog of "UAC On": re-enforces a password prompt for privilege escalation
# by finding and neutralising passwordless-sudo (NOPASSWD) rules.
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
echo "${C_CY}  Script: Sudo_Password_On.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Admin & Security${C_RS}"
echo "${C_CY}  Description: Re-enforces a password prompt for sudo by removing passwordless (NOPASSWD) rules${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

FILES="/etc/sudoers"
[ -d /etc/sudoers.d ] && FILES="$FILES $(find /etc/sudoers.d -type f 2>/dev/null)"

it_info "Scanning sudoers for passwordless (NOPASSWD) rules..."
hits=0
for f in $FILES; do
    [ -r "$f" ] || continue
    if grep -nE 'NOPASSWD' "$f" >/dev/null 2>&1; then
        hits=1
        it_warn "NOPASSWD found in: $f"
        grep -nE 'NOPASSWD' "$f" | sed 's/^/      /'
    fi
done

if [ "$hits" -eq 0 ]; then
    it_ok "No passwordless-sudo rules found. Privilege escalation already requires a password."
else
    echo
    go=$(it_ask "  Comment out every NOPASSWD rule now? Type YES: " "")
    if [ "$go" = "YES" ]; then
        for f in $FILES; do
            [ -w "$f" ] || continue
            if grep -qE 'NOPASSWD' "$f" 2>/dev/null; then
                it_run cp -f "$f" "${f}.bak_$(date +%Y%m%d_%H%M%S)"
                it_run sed -i -E 's/^([^#].*NOPASSWD)/# IT-Tool disabled: \1/' "$f"
                it_ok "Neutralised NOPASSWD rules in $f (backup kept)."
            fi
        done
        # Validate the resulting sudoers so we never lock the admin out.
        if command -v visudo >/dev/null 2>&1; then
            if visudo -cf /etc/sudoers >/dev/null 2>&1; then
                it_ok "sudoers syntax validated OK."
            else
                it_err "sudoers validation FAILED - review the .bak files immediately!"
            fi
        fi
    else
        it_note "No changes made."
    fi
fi

# Also make sure polkit is present so GUI privilege prompts work.
command -v pkaction >/dev/null 2>&1 && it_ok "polkit is installed (GUI actions will prompt for authentication)." \
                                    || it_note "polkit not detected; GUI apps may not prompt for elevation."

it_pause
