#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 470.Find_Text_In_Files.sh
# ScriptID: ST-LIN-0470
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files > Find And Search
# Description: Searches for text inside files recursively using grep.
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
echo -e '\033[0;36m  Script: 470.Find_Text_In_Files.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0470\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files > Find And Search\033[0m'
echo -e '\033[0;36m  Description: Searches for text inside files recursively using grep\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Text to search: " txt
read -rp "  Directory (Enter for current): " d
d="${d:-.}"

if [ -z "$txt" ]; then
    echo -e "${RED}  ERROR: Search text cannot be empty.${NC}"
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

echo ""
echo -e "${YELLOW}  Searching for '$txt' in '$d'...${NC}"
echo ""
grep -rn "$txt" "$d" 2>/dev/null

echo ""
read -rp "Press Enter to exit..." _
