#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 560.DNS_Full_Enum.sh
# ScriptID: ST-LIN-0560
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Recon And OSINT
# Description: Performs a full DNS enumeration of A, MX, NS, TXT and other records.
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
echo -e '\033[0;36m  Script: 560.DNS_Full_Enum.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0560\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Recon And OSINT\033[0m'
echo -e '\033[0;36m  Description: Performs a full DNS enumeration of A, MX, NS, TXT and other records\033[0m'
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

read -rp "  Domain to enumerate: " d

if [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Domain cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Enumerating DNS records for '$d'...${NC}"
echo ""
for type in A AAAA MX NS TXT CNAME SOA; do
    echo "=== $type ==="
    dig "$d" "$type" +short
done

echo ""
echo -e "${GREEN}  SUCCESS: DNS enumeration of '$d' completed.${NC}"

echo ""
read -rp "Press Enter to exit..." _
