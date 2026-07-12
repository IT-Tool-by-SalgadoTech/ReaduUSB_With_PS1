#!/usr/bin/env bash
# ScriptID: ST-LIN-0633  |  633.Remote_ports_activity.sh
# Displays all established TCP connections to remote hosts with the owning process.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];       then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ];    then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "633.Remote_ports_activity.sh" "ST-LIN-0633" "Lists established TCP connections to remote addresses with their owning process"
it_want_root   # process names for other users' sockets need root

# ss state established, numeric, with process; drop loopback/self.
rows=$(ss -tnp state established 2>/dev/null | awk 'NR>1')
if [ -z "$rows" ]; then
    it_warn "No established remote TCP connections found."
    it_pause; exit 0
fi

printf '    %-24s %-24s %s\n' "LOCAL" "REMOTE" "PROCESS"
printf '    %s\n' "--------------------------------------------------------------------------"
printed=0
printf '%s\n' "$rows" | while read -r recvq sendq local peer proc; do
    case "$peer" in 127.0.0.1:*|[::1]:*|"$local") continue ;; esac
    p=$(printf '%s' "$proc" | grep -oE 'users:\(\("[^"]+",pid=[0-9]+' | sed -E 's/users:\(\("([^"]+)",pid=([0-9]+)/\1(\2)/')
    [ -z "$p" ] && p="-"
    printf '    %-24s %-24s %s\n' "$local" "$peer" "$p"
done

it_ok "Remote connections listed successfully."
it_pause
