#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 561.WiFi_Scan_iwlist.sh
# ScriptID: ST-LIN-0561
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > WiFi Wireless
# Description: Scans for nearby WiFi networks on an interface using iwlist.
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
echo -e '\033[0;36m  Script: 561.WiFi_Scan_iwlist.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0561\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > WiFi Wireless\033[0m'
echo -e '\033[0;36m  Description: Scans for nearby WiFi networks on an interface using iwlist\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v iwlist &>/dev/null; then
    echo -e "${RED}  ERROR: iwlist is not installed (wireless-tools).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Wireless interface (e.g. wlan0): " i

if [ -z "$i" ]; then
    echo -e "${RED}  ERROR: Interface cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Scanning on '$i'...${NC}"
iwlist "$i" scan | grep -E "ESSID|Channel|Quality|Encryption|Address"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Scan on '$i' completed.${NC}"
else
    echo -e "${RED}  ERROR: Scan on '$i' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
