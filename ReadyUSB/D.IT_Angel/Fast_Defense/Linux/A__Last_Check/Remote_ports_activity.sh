#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Remote_ports_activity.sh
# Displays all established TCP connections to remote hosts with the owning process.
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
echo "${C_CY}  Script: Remote_ports_activity.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Networks${C_RS}"
echo "${C_CY}  Description: Lists established TCP connections to remote addresses with their owning process${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
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
