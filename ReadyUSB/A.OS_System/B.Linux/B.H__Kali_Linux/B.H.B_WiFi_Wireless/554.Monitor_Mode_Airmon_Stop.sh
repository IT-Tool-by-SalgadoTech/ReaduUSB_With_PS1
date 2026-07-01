#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 556.Monitor_Mode_Airmon_Stop.sh
# ScriptID: ST-LIN-0556
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > WiFi Wireless
# Description: Stops airmon-ng monitor mode and restarts NetworkManager.
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
echo -e '\033[0;36m  Script: 556.Monitor_Mode_Airmon_Stop.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0556\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > WiFi Wireless\033[0m'
echo -e '\033[0;36m  Description: Stops airmon-ng monitor mode and restarts NetworkManager\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v airmon-ng &>/dev/null; then
    echo -e "${RED}  ERROR: airmon-ng is not installed (aircrack-ng suite).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Monitor interface (e.g. wlan0mon): " i

if [ -z "$i" ]; then
    echo -e "${RED}  ERROR: Interface cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Stopping monitor mode on '$i'...${NC}"
airmon-ng stop "$i"
echo -e "${YELLOW}  Restarting NetworkManager...${NC}"
if command -v systemctl &>/dev/null; then
    systemctl restart NetworkManager
else
    service NetworkManager restart
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Monitor mode stopped.${NC}"
else
    echo -e "${RED}  ERROR: Failed to fully restore managed mode.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
