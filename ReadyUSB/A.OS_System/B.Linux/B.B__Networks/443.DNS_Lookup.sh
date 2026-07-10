#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 443.DNS_Lookup.sh
# ScriptID: ST-LIN-0443
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks
# Description: Performs a DNS lookup for a given domain name.
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
echo -e '\033[0;36m  Script: 443.DNS_Lookup.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0443\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks\033[0m'
echo -e '\033[0;36m  Description: Performs a DNS lookup for a given domain name\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Domain to resolve: " d

if [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Domain cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Resolving '$d'...${NC}"
echo ""
if command -v nslookup &>/dev/null; then
    nslookup "$d"
elif command -v dig &>/dev/null; then
    dig "$d" +short
else
    echo -e "${RED}  ERROR: Neither nslookup nor dig is installed (package dnsutils/bind-utils/bind).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
read -rp "Press Enter to exit..." _
