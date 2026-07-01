#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 476.Create_Symbolic_Link.sh
# ScriptID: ST-LIN-0476
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files
# Description: Creates a symbolic link to a file or folder.
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
echo -e '\033[0;36m  Script: 476.Create_Symbolic_Link.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0476\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files\033[0m'
echo -e '\033[0;36m  Description: Creates a symbolic link to a file or folder\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Source file/folder: " src
read -rp "  Link name/path: " lnk

if [ -z "$src" ] || [ -z "$lnk" ]; then
    echo -e "${RED}  ERROR: Source and link name cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -e "$src" ]; then
    echo -e "${RED}  ERROR: Source '$src' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Creating symbolic link '$lnk' -> '$src'...${NC}"
ln -s "$src" "$lnk"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Symlink created: $lnk -> $src${NC}"
else
    echo -e "${RED}  ERROR: Failed to create symbolic link.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
