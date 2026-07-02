#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 627.Symbolic_link.sh
# ScriptID: ST-LIN-0627
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux
# Description: Creates a symbolic link from a source path to a destination path.
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
echo -e '\033[0;36m  Script: 627.Symbolic_link.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0627\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux\033[0m'
echo -e '\033[0;36m  Description: Creates a symbolic link from a source path to a destination path\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Source path (link target): " source_folder
read -rp "  Destination path (link name): " destination_folder

if [ -z "$source_folder" ] || [ -z "$destination_folder" ]; then
    echo -e "${RED}  ERROR: Source and destination cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

source_folder="${source_folder/#\~/$HOME}"
destination_folder="${destination_folder/#\~/$HOME}"

if [ ! -e "$source_folder" ]; then
    echo -e "${RED}  ERROR: Source '$source_folder' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Creating symbolic link...${NC}"
ln -s "$source_folder" "$destination_folder"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Link '$destination_folder' -> '$source_folder' created.${NC}"
else
    echo -e "${RED}  ERROR: Failed to create the symbolic link.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
