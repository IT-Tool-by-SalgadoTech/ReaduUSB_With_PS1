#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 612.Copy_or_Paste.sh
# ScriptID: ST-LIN-0612
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux
# Description: Copies or moves a source folder into a destination folder.
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
echo -e '\033[0;36m  Script: 612.Copy_or_Paste.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0612\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux\033[0m'
echo -e '\033[0;36m  Description: Copies or moves a source folder into a destination folder\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Copy (c) or Move (m): " c
read -rp "  Source folder: " s
read -rp "  Destination folder: " d

if [ -z "$c" ] || [ -z "$s" ] || [ -z "$d" ]; then
    echo -e "${RED}  ERROR: All fields are required.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

# Expand a leading ~ to the user's home directory.
s="${s/#\~/$HOME}"
d="${d/#\~/$HOME}"
s="${s%/}"
d="${d%/}"

if [ ! -e "$s" ]; then
    echo -e "${RED}  ERROR: Source '$s' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
if [ "$c" = "m" ]; then
    echo -e "${YELLOW}  Moving '$s' into '$d/'...${NC}"
    mv -- "$s" "$d"/
elif [ "$c" = "c" ]; then
    echo -e "${YELLOW}  Copying '$s' into '$d/'...${NC}"
    cp -a -- "$s" "$d"/
else
    echo -e "${RED}  ERROR: Use c or m.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Operation completed.${NC}"
else
    echo -e "${RED}  ERROR: Operation failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
