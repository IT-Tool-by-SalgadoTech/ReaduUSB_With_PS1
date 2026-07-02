#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 578.Hydra_HTTP_Brute.sh
# ScriptID: ST-LIN-0578
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Password Tools
# Description: Brute-forces HTTP Basic Auth logins using Hydra.
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
echo -e '\033[0;36m  Script: 578.Hydra_HTTP_Brute.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0578\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Password Tools\033[0m'
echo -e '\033[0;36m  Description: Brute-forces HTTP Basic Auth logins using Hydra\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v hydra &>/dev/null; then
    echo -e "${RED}  ERROR: hydra is not installed. Run: sudo apt install hydra${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Target URL (e.g. http://192.168.1.1/login): " url
read -rp "  Username: " u
read -rp "  Wordlist path: " w

if [ -z "$url" ] || [ -z "$u" ] || [ -z "$w" ]; then
    echo -e "${RED}  ERROR: URL, username and wordlist are required.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -f "$w" ]; then
    echo -e "${RED}  ERROR: Wordlist '$w' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Brute-forcing HTTP login on '$url'...${NC}"
hydra -l "$u" -P "$w" -s 80 "$url" http-get /

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Hydra run against '$url' completed.${NC}"
else
    echo -e "${RED}  ERROR: Hydra run against '$url' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
