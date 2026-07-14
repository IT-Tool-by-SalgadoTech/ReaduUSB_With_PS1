#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 561.DNS_Zone_Transfer.sh
# ScriptID: ST-LIN-0561
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Recon And OSINT
# Description: Attempts a DNS zone transfer (AXFR) against a name server.
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
echo -e '\033[0;36m  Script: 561.DNS_Zone_Transfer.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0561\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Recon And OSINT\033[0m'
echo -e '\033[0;36m  Description: Attempts a DNS zone transfer (AXFR) against a name server\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v dig &>/dev/null; then
    echo -e "${RED}  ERROR: dig is not installed. Run: sudo apt install dnsutils${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Domain: " d

if [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Domain cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  DNS server (or Enter for auto): " ns
ns="${ns:-$(dig NS "$d" +short | head -1)}"

if [ -z "$ns" ]; then
    echo -e "${RED}  ERROR: Could not determine a DNS server for '$d'.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Attempting zone transfer of '$d' from '$ns'...${NC}"
dig axfr "$d" @"$ns"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Zone transfer request to '$ns' completed.${NC}"
else
    echo -e "${RED}  ERROR: Zone transfer request to '$ns' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
