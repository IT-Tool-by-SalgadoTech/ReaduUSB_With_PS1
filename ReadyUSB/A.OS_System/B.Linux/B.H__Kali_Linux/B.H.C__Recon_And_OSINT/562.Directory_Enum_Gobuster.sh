#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 562.Directory_Enum_Gobuster.sh
# ScriptID: ST-LIN-0562
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Recon And OSINT
# Description: Enumerates web directories and files on a target using gobuster.
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
echo -e '\033[0;36m  Script: 562.Directory_Enum_Gobuster.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0562\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Recon And OSINT\033[0m'
echo -e '\033[0;36m  Description: Enumerates web directories and files on a target using gobuster\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v gobuster &>/dev/null; then
    echo -e "${RED}  ERROR: gobuster is not installed. Run: sudo apt install gobuster${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Target URL (e.g. http://192.168.1.1): " u

if [ -z "$u" ]; then
    echo -e "${RED}  ERROR: Target URL cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Wordlist (Enter for default): " w
w="${w:-/usr/share/wordlists/dirb/common.txt}"

if [ ! -f "$w" ]; then
    echo -e "${RED}  ERROR: Wordlist '$w' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Enumerating directories on '$u'...${NC}"
gobuster dir -u "$u" -w "$w"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Directory enumeration of '$u' completed.${NC}"
else
    echo -e "${RED}  ERROR: Directory enumeration of '$u' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
