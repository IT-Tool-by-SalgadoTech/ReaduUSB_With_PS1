#!/usr/bin/env bash
# ScriptID: ST-LIN-0661  |  661.Enable_Firewall.sh
# Enables the host firewall using whichever manager is present (ufw / firewalld / nftables / iptables).
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "661.Enable_Firewall.sh" "ST-LIN-0661" "Enables the host firewall (ufw / firewalld / nftables / iptables) on all zones"
it_need_root "$@"

done_any=0
if command -v firewall-cmd >/dev/null 2>&1; then
    it_info "firewalld detected."
    it_service_enable firewalld; it_service_start firewalld
    if firewall-cmd --state >/dev/null 2>&1; then
        it_ok "firewalld is active. Default zones are enforcing."
        firewall-cmd --get-active-zones 2>/dev/null | sed 's/^/    /'
        done_any=1
    else
        it_warn "firewalld installed but not running (systemd may be inactive here)."
    fi
elif command -v ufw >/dev/null 2>&1; then
    it_info "ufw detected."
    if it_run ufw --force enable 2>/dev/null; then
        it_ok "ufw enabled."
        ufw status verbose 2>/dev/null | sed 's/^/    /'
        done_any=1
    else
        it_warn "ufw could not be enabled (needs a working firewall backend/root)."
    fi
fi

if [ "$done_any" -eq 0 ]; then
    it_note "No high-level firewall manager active; falling back to a default-deny inbound policy via iptables."
    if it_fw_ready; then
        it_run iptables -P INPUT DROP
        it_run iptables -I INPUT -i lo -j ACCEPT
        it_run iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
        it_ok "iptables default INPUT policy set to DROP (loopback + established allowed)."
        done_any=1
    fi
fi

[ "$done_any" -eq 0 ] && it_err "Could not enable any firewall on this host."
it_pause
