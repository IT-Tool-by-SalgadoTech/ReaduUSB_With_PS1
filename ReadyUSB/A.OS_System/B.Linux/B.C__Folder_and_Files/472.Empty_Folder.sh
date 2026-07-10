#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 472.Empty_Folder.sh
# ScriptID: ST-LIN-0472
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files
# Description: Deletes all contents of a folder without deleting the folder itself.
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
echo -e '\033[0;36m  Script: 472.Empty_Folder.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0472\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files\033[0m'
echo -e '\033[0;36m  Description: Deletes all contents of a folder without deleting the folder itself\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Folder to empty: " d

if [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Folder path cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -d "$d" ]; then
    echo -e "${RED}  ERROR: Directory '$d' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Type EMPTY to confirm: " c

if [ "$c" != "EMPTY" ]; then
    echo -e "${YELLOW}  Aborted. No changes were made.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Emptying folder '$d'...${NC}"
rm -rf "$d"/* "$d"/.[!.]* 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Folder '$d' emptied.${NC}"
else
    echo -e "${RED}  ERROR: Failed to empty folder '$d'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
