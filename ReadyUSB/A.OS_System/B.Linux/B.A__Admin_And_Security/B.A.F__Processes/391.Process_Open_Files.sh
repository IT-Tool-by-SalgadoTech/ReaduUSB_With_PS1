#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 391.Process_Open_Files.sh
# ScriptID: ST-LIN-0391
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Processes
# Description: Shows files opened by a process (by PID).
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
echo -e '\033[0;36m  Script: 391.Process_Open_Files.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0391\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Processes\033[0m'
echo -e '\033[0;36m  Description: Shows files opened by a process (by PID)\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v lsof &>/dev/null; then
    echo -e "${RED}  ERROR: lsof is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  PID: " pid

if [ -z "$pid" ]; then
    echo -e "${RED}  ERROR: PID cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}  ERROR: PID must be a number.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Showing open files for PID $pid...${NC}"
echo ""
lsof -p "$pid" 2>/dev/null | head -30

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}  SUCCESS: Open files for PID $pid displayed.${NC}"
else
    echo -e "${RED}  ERROR: Could not read open files for PID $pid.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
