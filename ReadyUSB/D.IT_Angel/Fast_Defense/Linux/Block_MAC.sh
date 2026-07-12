#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Block_MAC.sh
# Resolves a MAC to its current IP via the neighbour (ARP/ND) table and blocks it.
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
echo "${C_CY}  Script: Block_MAC.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Networks${C_RS}"
echo "${C_CY}  Description: Resolves a MAC via the neighbour table and blocks it (by IP and by source MAC)${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

macin=$(it_ask "Enter the MAC address of the device to block (any format): " "")
mac="$(it_norm_mac "$macin")"
if [ -z "$mac" ]; then it_err "'$macin' is not a valid MAC address (need 12 hex digits)."; it_pause; exit 1; fi
it_info "Normalized MAC: $mac"
echo

it_fw_ready || { it_pause; exit 1; }

it_info "Searching the neighbour table for this MAC..."
# ip neigh output: "<ip> dev <dev> lladdr <mac> <state>"
ips=$(ip neigh 2>/dev/null | awk -v m="$mac" 'tolower($0) ~ m && $1 ~ /\./ {print $1}' | sort -u)
if [ -z "$ips" ]; then
    # fallback to the arp tool if present
    ips=$(arp -an 2>/dev/null | awk -v m="$mac" 'tolower($0) ~ m {gsub(/[()]/,"",$2); print $2}' | sort -u)
fi

# Always add the layer-2 source-MAC catch-all even if no IP is known yet.
it_run iptables -I INPUT -m mac --mac-source "$mac" \
    -m comment --comment "ITTOOL_Block_MAC_${mac}_MAC" -j DROP 2>/dev/null \
    && it_ok "Layer-2 rule added: inbound frames from $mac are dropped."

if [ -z "$ips" ]; then
    echo
    it_warn "MAC '$mac' is not currently visible in the neighbour table (no IP mapped)."
    it_note "The device must be online/have communicated recently to map an IP."
    it_note "The layer-2 rule above still blocks its inbound frames. For a permanent"
    it_note "ban regardless of IP, also apply it on your router/switch."
    it_pause; exit 0
fi

it_ok "Resolved MAC to IP(s): $(echo "$ips" | tr '\n' ' ')"
created=0
for ip in $ips; do
    if it_fw_block_mac "$mac" "$ip"; then
        it_ok "  BLOCKED: $ip (inbound + outbound)"; created=$((created+1))
    else
        it_err "  ERROR blocking $ip"
    fi
done
echo
[ "$created" -gt 0 ] && it_ok "SUCCESS: Device '$mac' blocked on $created IP address(es)."
it_note "If the device uses DHCP its IP may change; re-run if it reconnects with a new IP."

it_pause
