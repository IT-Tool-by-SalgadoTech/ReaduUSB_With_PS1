#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 534.Nmap_Stealth_Scan.sh
# ScriptID: ST-LIN-0534
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Nmap
# Description: Runs a stealth SYN scan (-sS) that is less visible in target logs.
# (c) 2025 SalgadoTech - All Rights Reserved
# Unauthorized distribution prohibited
# ==============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "\033[0;31m  ERROR: This script requires root privileges.\033[0m"
    echo -e "\033[1;33m  Run with: sudo bash $(basename "$0")\033[0m"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

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
echo -e '\033[0;36m  Script: 534.Nmap_Stealth_Scan.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0534\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Nmap\033[0m'
echo -e '\033[0;36m  Description: Runs a stealth SYN scan (-sS) that is less visible in target logs\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v nmap &>/dev/null; then
    echo -e "${RED}  ERROR: nmap is not installed. Run the Nmap Install script first.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Target IP: " t

if [ -z "$t" ]; then
    echo -e "${RED}  ERROR: Target cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Running stealth SYN scan on '$t'...${NC}"
nmap -sS -T4 "$t"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Stealth scan of '$t' completed.${NC}"
else
    echo -e "${RED}  ERROR: Scan of '$t' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
