#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 563.Ping_Sweep_fping.sh
# ScriptID: ST-LIN-0563
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Recon And OSINT
# Description: Runs a fast ping sweep of a subnet to find live hosts using fping.
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
echo -e '\033[0;36m  Script: 563.Ping_Sweep_fping.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0563\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Recon And OSINT\033[0m'
echo -e '\033[0;36m  Description: Runs a fast ping sweep of a subnet to find live hosts using fping\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v fping &>/dev/null; then
    echo -e "${RED}  ERROR: fping is not installed. Run: sudo apt install fping${NC}"
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

echo ""
echo -e "${YELLOW}  Sweeping subnet '$s'...${NC}"
fping -a -g "$s"

echo -e "${GREEN}  SUCCESS: Ping sweep of '$s' completed.${NC}"

echo ""
read -rp "Press Enter to exit..." _
