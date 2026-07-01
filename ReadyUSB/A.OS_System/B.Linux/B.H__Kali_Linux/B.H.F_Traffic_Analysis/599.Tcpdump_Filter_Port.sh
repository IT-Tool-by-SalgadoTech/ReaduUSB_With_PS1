#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 599.Tcpdump_Filter_Port.sh
# ScriptID: ST-LIN-0599
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Traffic Analysis
# Description: Captures live traffic on a specific port using tcpdump.
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
echo -e '\033[0;36m  Script: 599.Tcpdump_Filter_Port.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0599\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Traffic Analysis\033[0m'
echo -e '\033[0;36m  Description: Captures live traffic on a specific port using tcpdump\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v tcpdump &>/dev/null; then
    echo -e "${RED}  ERROR: tcpdump is not installed. Run: apt install tcpdump${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Interface: " i
read -rp "  Port: " p

if [ -z "$i" ] || [ -z "$p" ]; then
    echo -e "${RED}  ERROR: Interface and port cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! [[ "$p" =~ ^[0-9]+$ ]] || [ "$p" -lt 1 ] || [ "$p" -gt 65535 ]; then
    echo -e "${RED}  ERROR: Port must be a number between 1 and 65535.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Capturing traffic on port '$p' via '$i' (Ctrl+C to stop)...${NC}"
tcpdump -i "$i" port "$p" -n

echo ""
read -rp "Press Enter to exit..." _
