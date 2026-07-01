#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 386.Kill_Process_By_Name.sh
# ScriptID: ST-LIN-0386
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Processes
# Description: Kills all processes matching a given name.
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
echo -e '\033[0;36m  Script: 386.Kill_Process_By_Name.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0386\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Processes\033[0m'
echo -e '\033[0;36m  Description: Kills all processes matching a given name\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Process name to kill: " p

if [ -z "$p" ]; then
    echo -e "${RED}  ERROR: Process name cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Killing all processes matching '$p'...${NC}"
pkill "$p"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Killed process(es) matching '$p'.${NC}"
else
    echo -e "${YELLOW}  No process found matching '$p'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
