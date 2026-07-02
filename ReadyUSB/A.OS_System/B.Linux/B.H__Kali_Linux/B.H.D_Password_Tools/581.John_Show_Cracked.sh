#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 581.John_Show_Cracked.sh
# ScriptID: ST-LIN-0581
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Password Tools
# Description: Shows previously cracked passwords from a John the Ripper hash file.
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
echo -e '\033[0;36m  Script: 581.John_Show_Cracked.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0581\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Password Tools\033[0m'
echo -e '\033[0;36m  Description: Shows previously cracked passwords from a John the Ripper hash file\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v john &>/dev/null; then
    echo -e "${RED}  ERROR: john is not installed. Run: sudo apt install john${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Hash file path: " f

if [ -z "$f" ]; then
    echo -e "${RED}  ERROR: Hash file cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -f "$f" ]; then
    echo -e "${RED}  ERROR: Hash file '$f' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Showing cracked passwords for '$f'...${NC}"
john "$f" --show

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Cracked passwords for '$f' listed.${NC}"
else
    echo -e "${RED}  ERROR: Could not list cracked passwords for '$f'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
