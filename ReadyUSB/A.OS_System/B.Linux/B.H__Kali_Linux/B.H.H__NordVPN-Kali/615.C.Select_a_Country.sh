#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 615.C.Select_a_Country.sh
# ScriptID: ST-LIN-0615
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > NordVPN
# Description: Lists available NordVPN countries and connects to the selected one.
# (c) 2025 SalgadoTech - All Rights Reserved
# Unauthorized distribution prohibited
# ==============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

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
echo -e '\033[0;36m  Script: 615.C.Select_a_Country.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0615\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > NordVPN\033[0m'
echo -e '\033[0;36m  Description: Lists available NordVPN countries and connects to the selected one\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v nordvpn &>/dev/null; then
    echo -e "${RED}  ERROR: nordvpn is not installed. Run script 614 first.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  Available countries:${NC}"
nordvpn countries

echo ""
read -rp "  Select Country: " country
if [ -z "$country" ]; then
    echo -e "${RED}  ERROR: Country cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Connecting to '$country'...${NC}"
nordvpn connect "$country"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Connected to '$country'.${NC}"
else
    echo -e "${RED}  ERROR: Failed to connect to '$country'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
