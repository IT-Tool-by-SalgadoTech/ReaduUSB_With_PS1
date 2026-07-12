#!/usr/bin/env bash
# ScriptID: ST-LIN-0665  |  668.Show_IPs_and_MACs.sh
# Sweeps the local subnet to list active device IP/MACs, shows local interface MACs,
# and lists all IP/MAC addresses currently blocked by IT-Tool.
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
echo "${C_CY}  Script: 665.Show_IPs_and_MACs.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0665${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Networks${C_RS}"
echo "${C_CY}  Description: Discovers active LAN devices (IP+MAC), lists local MACs and all IT-Tool blocks${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_want_root   # read-only; more complete as root but works either way

# --- Build the set of currently blocked IPs/MACs for cross-marking ----------
blocked_ips="$(it_fw_list_ips 2>/dev/null)"
blocked_macs="$(it_fw_list_macs 2>/dev/null | tr 'A-F' 'a-f')"

# --- Active discovery: ping-sweep each local IPv4 /24 so ARP populates -------
it_info "Scanning the local network to discover active devices..."
bases=$(ip -4 -o addr show scope global 2>/dev/null \
    | awk '{print $4}' | cut -d/ -f1 \
    | grep -vE '^(127\.|169\.254\.)' \
    | awk -F. '{print $1"."$2"."$3}' | sort -u)

for base in $bases; do
    for i in $(seq 1 254); do
        ping -c1 -W1 "${base}.${i}" >/dev/null 2>&1 &
    done
done
wait 2>/dev/null
sleep 1

# --- Render active devices from the neighbour table -------------------------
echo
it_info "ACTIVE network devices (from the neighbour/ARP table):"
printf '    %-18s %-16s %-10s %s\n' "MAC" "IP ADDRESS" "STATE" "BLOCKED"
printf '    %s\n' "----------------------------------------------------------------"
count=0
while read -r ipa _ _ mac state; do
    [ -z "$mac" ] && continue
    case "$mac" in *:*) : ;; *) continue ;; esac
    case "$ipa" in 0.0.0.0|"") continue ;; esac
    lmac="$(printf '%s' "$mac" | tr 'A-F' 'a-f')"
    tag="no"
    if printf '%s\n' "$blocked_macs" | grep -qx "$lmac" || printf '%s\n' "$blocked_ips" | grep -qx "$ipa"; then
        tag="BLOCKED"
    fi
    printf '    %-18s %-16s %-10s %s\n' "$mac" "$ipa" "$state" "$tag"
    count=$((count+1))
done < <(ip neigh 2>/dev/null | awk '$1 ~ /\./ && /lladdr/ {print $1, $2, $3, $5, $NF}')
[ "$count" -eq 0 ] && it_note "  (no active devices found)"
it_note "  Active device MACs found: $count"

# --- Local interface MACs ---------------------------------------------------
echo
it_info "LOCAL interface MACs (this machine):"
printf '    %-18s %-16s %s\n' "MAC" "INTERFACE" "STATE"
printf '    %s\n' "------------------------------------------------------"
ip -o link show 2>/dev/null | awk -F': ' '{print $2}' | sed 's/@.*//' | while read -r ifc; do
    [ "$ifc" = "lo" ] && continue
    mac=$(cat "/sys/class/net/$ifc/address" 2>/dev/null)
    st=$(cat "/sys/class/net/$ifc/operstate" 2>/dev/null)
    [ -n "$mac" ] && printf '    %-18s %-16s %s\n' "$mac" "$ifc" "$st"
done

# --- Blocked IPs ------------------------------------------------------------
echo
it_info "IP addresses BLOCKED by IT-Tool:"
if [ -z "$blocked_ips" ]; then
    it_note "  (none)"
else
    printf '%s\n' "$blocked_ips" | sed 's/^/    /'
    it_note "  Total blocked IPs: $(printf '%s\n' "$blocked_ips" | grep -c .)"
fi

# --- Blocked MACs -----------------------------------------------------------
echo
it_info "MAC addresses BLOCKED by IT-Tool:"
mlist="$(it_fw_list_macs 2>/dev/null)"
if [ -z "$mlist" ]; then
    it_note "  (none)"
else
    printf '%s\n' "$mlist" | sed 's/^/    /'
    it_note "  Total blocked MACs: $(printf '%s\n' "$mlist" | grep -c .)"
fi

it_note "Use 672.Unblock_suspicious_ip.sh / 673.Unblock_MAC.sh to remove blocks."
it_pause
