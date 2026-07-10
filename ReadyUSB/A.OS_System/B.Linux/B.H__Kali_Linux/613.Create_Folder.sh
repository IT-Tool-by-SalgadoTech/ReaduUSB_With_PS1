#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 613.Create_Folder.sh
# ScriptID: ST-LIN-0613
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux
# Description: Creates a folder (and parent folders) at a given path using mkdir -p.
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
echo -e '\033[0;36m  Script: 613.Create_Folder.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0613\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux\033[0m'
echo -e '\033[0;36m  Description: Creates a folder (and parent folders) at a given path using mkdir -p\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Path: " path

if [ -z "$path" ]; then
    echo -e "${RED}  ERROR: Path cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

path="${path/#\~/$HOME}"

echo ""
echo -e "${YELLOW}  Creating folder '$path'...${NC}"
mkdir -p "$path"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Folder '$path' created.${NC}"
else
    echo -e "${RED}  ERROR: Failed to create '$path'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
