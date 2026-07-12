#!/usr/bin/env bash
# ScriptID: ST-LIN  |  Reset_DNS.sh
# Resets DNS to automatic (DHCP) on active connections and flushes the resolver cache.
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
echo "${C_CY}  Script: Reset_DNS.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Networks${C_RS}"
echo "${C_CY}  Description: Resets DNS to automatic (DHCP) on active adapters and flushes the DNS cache${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

# Optional: pin a trusted resolver instead of automatic. Set USE_TRUSTED=1.
USE_TRUSTED="${USE_TRUSTED:-0}"
TRUSTED_DNS="1.1.1.1 1.0.0.1"
changed=0

# 1) NetworkManager-managed connections.
if command -v nmcli >/dev/null 2>&1 && nmcli -t g >/dev/null 2>&1; then
    conns=$(nmcli -t -f NAME,TYPE con show --active 2>/dev/null | awk -F: '$2 ~ /ethernet|wifi/ {print $1}')
    for c in $conns; do
        if [ "$USE_TRUSTED" = "1" ]; then
            it_run nmcli con mod "$c" ipv4.ignore-auto-dns yes ipv4.dns "$TRUSTED_DNS"
            it_ok "DNS set to trusted resolver on: $c"
        else
            it_run nmcli con mod "$c" ipv4.ignore-auto-dns no ipv4.dns ""
            it_ok "DNS reset to automatic on: $c"
        fi
        it_run nmcli con up "$c" >/dev/null 2>&1
        changed=1
    done
    [ -z "$conns" ] && it_note "NetworkManager active but no ethernet/wifi connections found."
else
    it_note "NetworkManager not active; skipping per-connection DNS reset."
fi

# 2) systemd-resolved: revert stub + flush.
if command -v resolvectl >/dev/null 2>&1; then
    it_run resolvectl flush-caches 2>/dev/null && it_ok "systemd-resolved cache flushed." && changed=1
fi

# 3) Generic caches (nscd / dnsmasq).
command -v nscd    >/dev/null 2>&1 && it_run nscd -i hosts 2>/dev/null && it_ok "nscd hosts cache invalidated."
it_service_restart dnsmasq 2>/dev/null

# 4) Show effective resolver.
echo
it_info "Current resolver configuration:"
if command -v resolvectl >/dev/null 2>&1 && resolvectl status >/dev/null 2>&1; then
    resolvectl status 2>/dev/null | grep -E 'Current DNS|DNS Servers' | sed 's/^/    /'
elif [ -r /etc/resolv.conf ]; then
    grep -E '^nameserver' /etc/resolv.conf 2>/dev/null | sed 's/^/    /' || it_note "  (no nameserver lines)"
fi

[ "$changed" -eq 0 ] && it_warn "No DNS manager could be reconfigured on this host."
it_pause
