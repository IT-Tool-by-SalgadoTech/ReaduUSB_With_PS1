#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 531.Nmap_Scan_LAN_Report.sh
# ScriptID: ST-LIN-0531
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Nmap
# Description: Scans an entire LAN subnet and saves the report to a file.
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
echo -e '\033[0;36m  Script: 531.Nmap_Scan_LAN_Report.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0531\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Nmap\033[0m'
echo -e '\033[0;36m  Description: Scans an entire LAN subnet and saves the report to a file\033[0m'
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

read -rp "  Subnet (e.g. 192.168.1.0/24): " s

if [ -z "$s" ]; then
    echo -e "${RED}  ERROR: Subnet cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

out="$HOME/nmap_scan_$(date +%Y%m%d_%H%M%S).txt"

echo ""
echo -e "${YELLOW}  Scanning '$s' and saving report...${NC}"
nmap -T4 -A "$s" -oN "$out"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Report saved to $out${NC}"
else
    echo -e "${RED}  ERROR: Scan of '$s' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
