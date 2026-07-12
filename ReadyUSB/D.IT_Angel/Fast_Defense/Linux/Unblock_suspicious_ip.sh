#!/usr/bin/env bash
# ScriptID: ST-LIN-0672  |  672.Unblock_suspicious_ip.sh
# Removes IT-Tool firewall blocks created for a suspicious IP.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "672.Unblock_suspicious_ip.sh" "ST-LIN-0672" "Removes IT-Tool firewall blocks created for a suspicious IP"
it_need_root "$@"

it_fw_ready || { it_pause; exit 1; }

list="$(it_fw_list_ips)"
if [ -z "$list" ]; then
    it_warn "No IP blocks created by IT-Tool were found."
    it_pause; exit 0
fi

it_info "Currently blocked IP addresses:"
i=0
for ip in $list; do i=$((i+1)); printf '    [%d] %s\n' "$i" "$ip"; done

choice=$(it_ask "Enter the IP to unblock, or type ALL to remove every IT-Tool IP block: " "")
choice="$(printf '%s' "$choice" | tr -d '[:space:]')"
[ -z "$choice" ] && { it_warn "No selection made. Nothing changed."; it_pause; exit 0; }

if [ "$choice" = "ALL" ] || [ "$choice" = "all" ]; then
    n=0
    for ip in $list; do it_fw_unblock_ip "$ip" && n=$((n+1)); done
    it_ok "SUCCESS: Removed IT-Tool blocks for $n IP address(es)."
else
    if ! it_valid_ip "$choice"; then it_err "'$choice' is not a valid IP address."; it_pause; exit 1; fi
    if printf '%s\n' "$list" | grep -qx "$choice"; then
        it_fw_unblock_ip "$choice" && it_ok "SUCCESS: Unblocked '$choice'."
    else
        it_warn "No IT-Tool block found for '$choice'."
    fi
fi

it_pause
