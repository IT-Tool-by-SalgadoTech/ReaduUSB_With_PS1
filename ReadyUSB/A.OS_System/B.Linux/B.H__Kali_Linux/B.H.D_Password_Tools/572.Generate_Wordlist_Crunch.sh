#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 572.Generate_Wordlist_Crunch.sh
# ScriptID: ST-LIN-0572
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Password Tools
# Description: Generates a custom wordlist with crunch from a length range and charset.
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
echo -e '\033[0;36m  Script: 572.Generate_Wordlist_Crunch.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0572\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Password Tools\033[0m'
echo -e '\033[0;36m  Description: Generates a custom wordlist with crunch from a length range and charset\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v crunch &>/dev/null; then
    echo -e "${RED}  ERROR: crunch is not installed. Run: sudo apt install crunch${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Min length: " min
read -rp "  Max length: " max
read -rp "  Charset (e.g. abc123 or @,%^): " cs
read -rp "  Output file: " out

if [ -z "$min" ] || [ -z "$max" ] || [ -z "$cs" ] || [ -z "$out" ]; then
    echo -e "${RED}  ERROR: All fields are required.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Generating wordlist to '$out'...${NC}"
crunch "$min" "$max" "$cs" -o "$out"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Wordlist saved to '$out'.${NC}"
else
    echo -e "${RED}  ERROR: Wordlist generation failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
