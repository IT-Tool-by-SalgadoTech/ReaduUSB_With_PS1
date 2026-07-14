#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 576.Hydra_SSH_Brute.sh
# ScriptID: ST-LIN-0576
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Password Tools
# Description: Brute-forces SSH logins using Hydra.
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
echo -e '\033[0;36m  Script: 576.Hydra_SSH_Brute.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0576\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Password Tools\033[0m'
echo -e '\033[0;36m  Description: Brute-forces SSH logins using Hydra\033[0m'
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

read -rp "  Target IP: " ip
read -rp "  Username (or file path with @): " u
read -rp "  Wordlist path: " w

if [ -z "$ip" ] || [ -z "$u" ] || [ -z "$w" ]; then
    echo -e "${RED}  ERROR: Target IP, username and wordlist are required.${NC}"
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
echo -e "${YELLOW}  Brute-forcing SSH login on '$ip'...${NC}"
hydra -l "$u" -P "$w" "$ip" ssh -t 4

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Hydra run against '$ip' completed.${NC}"
else
    echo -e "${RED}  ERROR: Hydra run against '$ip' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
