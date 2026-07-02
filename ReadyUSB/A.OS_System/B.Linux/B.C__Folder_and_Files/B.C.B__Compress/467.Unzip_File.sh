#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 467.Unzip_File.sh
# ScriptID: ST-LIN-0467
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files > Compress
# Description: Extracts a .zip file into a destination folder.
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
echo -e '\033[0;36m  Script: 467.Unzip_File.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0467\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files > Compress\033[0m'
echo -e '\033[0;36m  Description: Extracts a .zip file into a destination folder\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Zip file path: " z
read -rp "  Destination folder: " d

if [ -z "$z" ] || [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Zip path and destination cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -f "$z" ]; then
    echo -e "${RED}  ERROR: Zip file '$z' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! command -v unzip &>/dev/null; then
    echo -e "${RED}  ERROR: 'unzip' is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Extracting '$z' to '$d'...${NC}"
unzip "$z" -d "$d"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Extracted to '$d'.${NC}"
else
    echo -e "${RED}  ERROR: Failed to extract zip file.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
