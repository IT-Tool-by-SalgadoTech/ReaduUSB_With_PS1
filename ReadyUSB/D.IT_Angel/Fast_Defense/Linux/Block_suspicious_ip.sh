#!/usr/bin/env bash
# ScriptID: ST-LIN-0651  |  651.Block_suspicious_ip.sh
# Blocks all inbound and outbound traffic to a suspicious IP via iptables/ip6tables.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "651.Block_suspicious_ip.sh" "ST-LIN-0651" "Blocks inbound+outbound traffic to a suspicious IP via the host firewall"
it_need_root "$@"

ip=$(it_ask "Enter the suspicious IP address to block (IPv4 or IPv6): " "")
ip="$(printf '%s' "$ip" | tr -d '[:space:]')"
if [ -z "$ip" ]; then it_err "No IP address provided."; it_pause; exit 1; fi
if ! it_valid_ip "$ip"; then it_err "'$ip' is not a valid IP address."; it_pause; exit 1; fi

case "$ip" in
    127.0.0.1|::1|0.0.0.0|169.254.*|fe80:*)
        it_warn "'$ip' is a local/loopback address. Blocking it may affect this system."
        go=$(it_ask "  Type YES to continue anyway: " "")
        [ "$go" != "YES" ] && { it_warn "Cancelled by user."; it_pause; exit 0; }
        ;;
esac

it_fw_ready || { it_pause; exit 1; }

if it_fw_ip_blocked "$ip"; then
    it_warn "NOTICE: IP '$ip' is already blocked by IT-Tool."
    it_warn "Use 672.Unblock_suspicious_ip.sh to remove the block."
    it_pause; exit 0
fi

if it_fw_block_ip "$ip"; then
    it_ok "SUCCESS: Firewall block applied for '$ip' (inbound + outbound)."
else
    it_err "Failed to create firewall rules for '$ip'."; it_pause; exit 1
fi

echo
it_info "Active connections currently open to '$ip':"
conns=$(ss -tnp 2>/dev/null | awk -v ip="$ip" 'NR>1 && index($0, ip){print "    "$0}')
if [ -z "$conns" ]; then
    it_note "  (none found)"
else
    printf '%s\n' "$conns"
    it_note "The rule blocks new packets immediately; existing sockets may linger until they time out."
fi

it_pause
