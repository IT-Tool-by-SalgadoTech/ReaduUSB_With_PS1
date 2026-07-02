#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 619.Copy_and_Paste_Kali.sh
# ScriptID: ST-LIN-0619
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux
# Description: Copies or moves a file or folder to a destination, optionally renaming it.
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
echo -e '\033[0;36m  Script: 619.Copy_and_Paste_Kali.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0619\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux\033[0m'
echo -e '\033[0;36m  Description: Copies or moves a file or folder to a destination, optionally renaming it\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Action (copy/move): " act
read -rp "  Source path: " src

if [ -z "$act" ] || [ -z "$src" ]; then
    echo -e "${RED}  ERROR: Action and source path cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ "$act" != "copy" ] && [ "$act" != "move" ]; then
    echo -e "${RED}  ERROR: Action must be 'copy' or 'move'.${NC}"
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

read -rp "  Use same name? (y/n): " same
if [ "$same" = "n" ]; then
    read -rp "  New name: " new
    if [ -z "$new" ]; then
        echo -e "${RED}  ERROR: New name cannot be empty.${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
    fi
else
    new=$(basename "$src")
fi

read -rp "  Destination path: " dst
if [ -z "$dst" ]; then
    echo -e "${RED}  ERROR: Destination path cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
if [ "$act" = "copy" ]; then
    echo -e "${YELLOW}  Copying '$src' to '$dst/$new'...${NC}"
    cp -r "$src" "$dst/$new"
else
    echo -e "${YELLOW}  Moving '$src' to '$dst/$new'...${NC}"
    mv "$src" "$dst/$new"
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Operation completed.${NC}"
else
    echo -e "${RED}  ERROR: Operation failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
