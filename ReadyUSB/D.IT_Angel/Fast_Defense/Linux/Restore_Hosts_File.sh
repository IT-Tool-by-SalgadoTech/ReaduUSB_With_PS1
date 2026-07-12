#!/usr/bin/env bash
# ScriptID: ST-LIN-0663  |  666.Restore_Hosts_File.sh
# Backs up /etc/hosts then restores it to a clean Linux default to undo DNS-hijack entries.
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
echo "${C_CY}  Script: 663.Restore_Hosts_File.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0663${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Networks${C_RS}"
echo "${C_CY}  Description: Backs up and restores /etc/hosts to a clean default to undo hijack entries${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

HOSTS=/etc/hosts
if [ ! -f "$HOSTS" ]; then it_err "hosts file not found at $HOSTS."; it_pause; exit 1; fi

# Preserve the machine's own hostname for the 127.0.1.1 line (Debian convention).
HN="$(hostname 2>/dev/null || echo localhost)"

stamp="$(date +%Y%m%d_%H%M%S)"
backup="${HOSTS}.bak_${stamp}"
if it_run cp -f "$HOSTS" "$backup" 2>/dev/null; then
    it_ok "Backup created: $backup"
else
    it_err "Could not back up the current hosts file. Aborting."; it_pause; exit 1
fi

# Clear an immutable flag if an attacker set one.
command -v chattr >/dev/null 2>&1 && it_run chattr -i "$HOSTS" 2>/dev/null

read -r -d '' DEFAULT <<EOF
# /etc/hosts - restored to clean default by IT-Tool 666
127.0.0.1	localhost
127.0.1.1	${HN}

# The following lines are desirable for IPv6 capable hosts
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters
EOF

if [ -n "${IT_DRYRUN:-}" ]; then
    printf '  %s[DRYRUN]%s would overwrite %s with clean default\n' "$C_YL" "$C_RS" "$HOSTS"
elif printf '%s\n' "$DEFAULT" > "$HOSTS" 2>/dev/null; then
    it_ok "hosts file restored to a clean default (hostname preserved: $HN)."
else
    it_err "Could not write the default hosts file. Previous content kept in the backup above."
    it_pause; exit 1
fi

# Flush resolver caches so stale hijacked lookups are dropped.
command -v resolvectl >/dev/null 2>&1 && it_run resolvectl flush-caches 2>/dev/null && it_ok "DNS cache flushed."

it_pause
