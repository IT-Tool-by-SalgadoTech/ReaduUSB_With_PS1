#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 562.Nikto_Web_Scan.sh
# ScriptID: ST-LIN-0562
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Recon And OSINT
# Description: Scans a web server for known vulnerabilities using nikto.
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
echo -e '\033[0;36m  Script: 562.Nikto_Web_Scan.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0562\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Recon And OSINT\033[0m'
echo -e '\033[0;36m  Description: Scans a web server for known vulnerabilities using nikto\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v nikto &>/dev/null; then
    echo -e "${RED}  ERROR: nikto is not installed. Run: sudo apt install nikto${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Target URL or IP: " t

if [ -z "$t" ]; then
    echo -e "${RED}  ERROR: Target cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Scanning '$t' with nikto...${NC}"
nikto -h "$t"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Nikto scan of '$t' completed.${NC}"
else
    echo -e "${RED}  ERROR: Nikto scan of '$t' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
