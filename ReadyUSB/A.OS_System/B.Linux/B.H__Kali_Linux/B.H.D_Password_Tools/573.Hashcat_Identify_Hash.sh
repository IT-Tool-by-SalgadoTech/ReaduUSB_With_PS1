#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 573.Hashcat_Identify_Hash.sh
# ScriptID: ST-LIN-0573
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Password Tools
# Description: Identifies the likely type of a given hash using hashid.
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
echo -e '\033[0;36m  Script: 573.Hashcat_Identify_Hash.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0573\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Password Tools\033[0m'
echo -e '\033[0;36m  Description: Identifies the likely type of a given hash using hashid\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Hash to identify: " h

if [ -z "$h" ]; then
    echo -e "${RED}  ERROR: Hash cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Identifying hash...${NC}"
if command -v hashid &>/dev/null; then
    hashid "$h"
elif command -v hashcat &>/dev/null; then
    hashcat --identify "$h"
else
    echo -e "${RED}  ERROR: hashid is not installed. Run: sudo apt install hashid${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${GREEN}  SUCCESS: Hash identification completed.${NC}"

echo ""
read -rp "Press Enter to exit..." _
