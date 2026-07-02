#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 426.WiFi_Connect.sh
# ScriptID: ST-LIN-0426
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > WiFi
# Description: Connects to a WiFi network using nmcli.
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
echo -e '\033[0;36m  Script: 426.WiFi_Connect.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0426\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > WiFi\033[0m'
echo -e '\033[0;36m  Description: Connects to a WiFi network\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v nmcli &>/dev/null; then
    echo -e "${RED}  ERROR: nmcli (NetworkManager) is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  SSID (network name): " s
read -rp "  Password: " p

if [ -z "$s" ] || [ -z "$p" ]; then
    echo -e "${RED}  ERROR: SSID and password cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Connecting to '$s'...${NC}"
nmcli dev wifi connect "$s" password "$p"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Connected to '$s'.${NC}"
else
    echo -e "${RED}  ERROR: Failed to connect to '$s'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
