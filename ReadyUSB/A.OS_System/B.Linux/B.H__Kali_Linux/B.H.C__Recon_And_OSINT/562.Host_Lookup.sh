#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 562.Host_Lookup.sh
# ScriptID: ST-LIN-0562
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Recon And OSINT
# Description: Performs a DNS and reverse DNS lookup for an IP or domain.
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
echo -e '\033[0;36m  Script: 562.Host_Lookup.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0562\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Recon And OSINT\033[0m'
echo -e '\033[0;36m  Description: Performs a DNS and reverse DNS lookup for an IP or domain\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v host &>/dev/null; then
    echo -e "${RED}  ERROR: host is not installed. Run: sudo apt install bind9-host${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  IP or domain: " t

if [ -z "$t" ]; then
    echo -e "${RED}  ERROR: Target cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Looking up '$t'...${NC}"
host "$t"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Lookup of '$t' completed.${NC}"
else
    echo -e "${RED}  ERROR: Lookup of '$t' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
