#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 580.John_Crack_File.sh
# ScriptID: ST-LIN-0580
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Password Tools
# Description: Cracks password hashes from a file using John the Ripper.
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
echo -e '\033[0;36m  Script: 580.John_Crack_File.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0580\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Password Tools\033[0m'
echo -e '\033[0;36m  Description: Cracks password hashes from a file using John the Ripper\033[0m'
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

read -rp "  Wordlist (Enter for default): " w

echo ""
echo -e "${YELLOW}  Cracking hashes in '$f'...${NC}"
if [ -z "$w" ]; then
    john "$f"
else
    john "$f" --wordlist="$w"
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: John run on '$f' completed.${NC}"
else
    echo -e "${RED}  ERROR: John run on '$f' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
