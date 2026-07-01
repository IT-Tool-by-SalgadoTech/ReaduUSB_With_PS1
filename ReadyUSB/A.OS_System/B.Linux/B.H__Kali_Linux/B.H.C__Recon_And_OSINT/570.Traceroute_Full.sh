#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 572.Traceroute_Full.sh
# ScriptID: ST-LIN-0572
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Recon And OSINT
# Description: Traces the network path to a target with detailed hops.
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
echo -e '\033[0;36m  Script: 572.Traceroute_Full.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0572\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Recon And OSINT\033[0m'
echo -e '\033[0;36m  Description: Traces the network path to a target with detailed hops\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v traceroute &>/dev/null; then
    echo -e "${RED}  ERROR: traceroute is not installed. Run: sudo apt install traceroute${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Target IP or domain: " t

if [ -z "$t" ]; then
    echo -e "${RED}  ERROR: Target cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Tracing route to '$t'...${NC}"
traceroute -I "$t" || traceroute "$t"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Traceroute to '$t' completed.${NC}"
else
    echo -e "${RED}  ERROR: Traceroute to '$t' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
