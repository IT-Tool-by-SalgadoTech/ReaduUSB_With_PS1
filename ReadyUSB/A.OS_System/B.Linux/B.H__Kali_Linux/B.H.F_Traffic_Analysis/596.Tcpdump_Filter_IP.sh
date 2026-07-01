#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 598.Tcpdump_Filter_IP.sh
# ScriptID: ST-LIN-0598
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Traffic Analysis
# Description: Captures live traffic to or from a specific IP address using tcpdump.
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
echo -e '\033[0;36m  Script: 598.Tcpdump_Filter_IP.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0598\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Traffic Analysis\033[0m'
echo -e '\033[0;36m  Description: Captures live traffic to or from a specific IP address using tcpdump\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v tcpdump &>/dev/null; then
    echo -e "${RED}  ERROR: tcpdump is not installed. Run: apt install tcpdump${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Interface: " i
read -rp "  Target IP: " ip

if [ -z "$i" ] || [ -z "$ip" ]; then
    echo -e "${RED}  ERROR: Interface and target IP cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo -e "${RED}  ERROR: Invalid IP address: $ip${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Capturing traffic for '$ip' on '$i' (Ctrl+C to stop)...${NC}"
tcpdump -i "$i" host "$ip" -n

echo ""
read -rp "Press Enter to exit..." _
