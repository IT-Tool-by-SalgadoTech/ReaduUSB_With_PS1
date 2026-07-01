#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 350.UFW_Block_IP.sh
# ScriptID: ST-LIN-0350
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Firewall UFW
# Description: Blocks all incoming traffic from a specific IP address via UFW.
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
echo -e '\033[0;36m  Script: 350.UFW_Block_IP.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0350\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Firewall UFW\033[0m'
echo -e '\033[0;36m  Description: Blocks all incoming traffic from a specific IP address via UFW\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v ufw &>/dev/null; then
    echo -e "${RED}  ERROR: ufw is not installed. Install it first.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  IP address to block: " ip

if [ -z "$ip" ]; then
    echo -e "${RED}  ERROR: IP address cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo -e "${RED}  ERROR: '$ip' is not a valid IPv4 address.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Blocking all traffic from $ip...${NC}"
ufw deny from "$ip"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Blocked all traffic from $ip.${NC}"
else
    echo -e "${RED}  ERROR: Failed to block traffic from $ip.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
