#!/usr/bin/env bash
# ScriptID: ST-LIN-0663  |  663.Remove_allow_3389.sh
# Removes any inbound Allow rule for RDP port 3389 (ufw / firewalld / iptables).
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "663.Remove_allow_3389.sh" "ST-LIN-0663" "Removes the firewall rule that allows inbound RDP port 3389"
it_need_root "$@"

removed=0

# ufw: delete allow rules for 3389
if command -v ufw >/dev/null 2>&1; then
    for proto in tcp udp; do
        it_run ufw delete allow 3389/$proto >/dev/null 2>&1 && removed=1
    done
    it_run ufw delete allow 3389 >/dev/null 2>&1 && removed=1
    [ "$removed" -eq 1 ] && it_ok "ufw: allow rule(s) for 3389 removed."
fi

# firewalld: remove the rdp service / 3389 port from the default zone
if command -v firewall-cmd >/dev/null 2>&1 && firewall-cmd --state >/dev/null 2>&1; then
    it_run firewall-cmd --permanent --remove-service=rdp >/dev/null 2>&1 && removed=1
    it_run firewall-cmd --permanent --remove-port=3389/tcp >/dev/null 2>&1 && removed=1
    it_run firewall-cmd --reload >/dev/null 2>&1
    it_ok "firewalld: RDP service / port 3389 removed from the active zone."
fi

# iptables: delete ACCEPT rules referencing 3389
if it_fw_ready; then
    for b in iptables ip6tables; do
        command -v "$b" >/dev/null 2>&1 || continue
        "$b"-save 2>/dev/null | grep -E '\-\-dport 3389\b' | grep -E 'ACCEPT' | while read -r line; do
            it_run "$b" -D ${line#-A } 2>/dev/null
        done
    done
    it_ok "iptables: any ACCEPT rule for 3389 removed."
    removed=1
fi

[ "$removed" -eq 0 ] && it_warn "No allow rule for 3389 was found (or no firewall present)."
it_pause
