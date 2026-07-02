#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 471.Find_Large_Files.sh
# ScriptID: ST-LIN-0471
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files > Find And Search
# Description: Finds files larger than a specified size using find.
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
echo -e '\033[0;36m  Script: 471.Find_Large_Files.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0471\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files > Find And Search\033[0m'
echo -e '\033[0;36m  Description: Finds files larger than a specified size using find\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Minimum size (e.g. 100M, 1G): " s
read -rp "  Search in directory (Enter for /home): " d
d="${d:-/home}"

if [ -z "$s" ]; then
    echo -e "${RED}  ERROR: Minimum size cannot be empty.${NC}"
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
echo -e "${YELLOW}  Searching for files larger than '$s' in '$d' (top 20)...${NC}"
echo ""
find "$d" -type f -size +"$s" -exec ls -lh {} \; 2>/dev/null | sort -k5 -rh | head -20

echo ""
read -rp "Press Enter to exit..." _
