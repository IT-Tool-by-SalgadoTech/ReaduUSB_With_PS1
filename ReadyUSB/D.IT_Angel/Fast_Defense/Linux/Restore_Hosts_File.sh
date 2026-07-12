#!/usr/bin/env bash
# ScriptID: ST-LIN-0666  |  666.Restore_Hosts_File.sh
# Backs up /etc/hosts then restores it to a clean Linux default to undo DNS-hijack entries.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "666.Restore_Hosts_File.sh" "ST-LIN-0666" "Backs up and restores /etc/hosts to a clean default to undo hijack entries"
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
