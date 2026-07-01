#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 368.Clear_Journalctl.sh
# ScriptID: ST-LIN-0368
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Logs
# Description: Clears journalctl logs older than 7 days.
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
echo -e '\033[0;36m  Script: 368.Clear_Journalctl.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0368\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Logs\033[0m'
echo -e '\033[0;36m  Description: Clears journalctl logs older than 7 days\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v journalctl &>/dev/null; then
    echo -e "${RED}  ERROR: journalctl is not available on this system.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  This will permanently remove journal logs older than 7 days.${NC}"
read -rp "  Type CLEAR to confirm: " c

if [ "$c" != "CLEAR" ]; then
    echo -e "${YELLOW}  Aborted. No logs were removed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Removing old journal logs...${NC}"
journalctl --vacuum-time=7d

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Journal logs older than 7 days have been removed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to clear journal logs.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
