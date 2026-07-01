#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 360.List_Failed_Services.sh
# ScriptID: ST-LIN-0360
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Services
# Description: Shows all systemd services in a failed state.
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
echo -e '\033[0;36m  Script: 360.List_Failed_Services.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0360\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Services\033[0m'
echo -e '\033[0;36m  Description: Shows all systemd services in a failed state\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Listing failed services...${NC}"
echo ""
systemctl --failed

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}  SUCCESS: Failed services listed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to list failed services.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
