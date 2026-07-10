#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 478.Show_Hidden_Files.sh
# ScriptID: ST-LIN-0478
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files
# Description: Shows hidden files and folders in a directory.
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
echo -e '\033[0;36m  Script: 478.Show_Hidden_Files.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0478\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files\033[0m'
echo -e '\033[0;36m  Description: Shows hidden files and folders in a directory\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Directory path (Enter for current): " d
d="${d:-.}"

if [ ! -d "$d" ]; then
    echo -e "${RED}  ERROR: Directory '$d' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Hidden files and folders in '$d':${NC}"
echo ""
ls -la "$d" | grep "^\."

echo ""
read -rp "Press Enter to exit..." _
