#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 544.IPTables_Block_IP.sh
# ScriptID: ST-LIN-0544
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Firewall IPTables
# Description: Blocks all inbound and outbound traffic for a specific IP using iptables.
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
echo -e '\033[0;36m  Script: 544.IPTables_Block_IP.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0544\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Firewall IPTables\033[0m'
echo -e '\033[0;36m  Description: Blocks all inbound and outbound traffic for a specific IP using iptables\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v iptables &>/dev/null; then
    echo -e "${RED}  ERROR: iptables is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  IP to block: " ip

if [ -z "$ip" ]; then
    echo -e "${RED}  ERROR: IP cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! echo "$ip" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
    echo -e "${RED}  ERROR: Invalid IPv4 address: '$ip'.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Blocking traffic to/from '$ip'...${NC}"
iptables -A INPUT -s "$ip" -j DROP && iptables -A OUTPUT -d "$ip" -j DROP

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: IP '$ip' blocked in both directions.${NC}"
else
    echo -e "${RED}  ERROR: Failed to block '$ip'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
