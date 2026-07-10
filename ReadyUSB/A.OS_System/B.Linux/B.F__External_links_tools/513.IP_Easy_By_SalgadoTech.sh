#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 513.IP_Easy_By_SalgadoTech.sh
# ScriptID: ST-LIN-0513
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > External Links Tools
# Description: Opens the IP Easy by SalgadoTech website in the default browser.
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
echo -e '\033[0;36m  Script: 513.IP_Easy_By_SalgadoTech.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0513\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > External Links Tools\033[0m'
echo -e '\033[0;36m  Description: Opens the IP Easy by SalgadoTech website in the default browser.\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

URL="https://it-tool-by-salgadotech.github.io/IP-Easy/"

if ! command -v xdg-open >/dev/null 2>&1; then
    echo -e "${RED}  ERROR: No graphical browser opener (xdg-open) is available.${NC}"
    echo -e "${RED}  Please open the following URL manually:${NC}"
    echo -e "${YELLOW}  $URL${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  Opening IP Easy by SalgadoTech ...${NC}"
xdg-open "$URL" >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: IP Easy by SalgadoTech opened in your default browser.${NC}"
else
    echo -e "${RED}  ERROR: Failed to open IP Easy by SalgadoTech.${NC}"
    echo -e "${RED}  Please open the following URL manually:${NC}"
    echo -e "${YELLOW}  $URL${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
