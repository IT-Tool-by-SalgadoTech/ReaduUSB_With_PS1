#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 403.Check_Sudo_Access.sh
# ScriptID: ST-LIN-0403
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security
# Description: Shows the current user sudo privileges.
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
echo -e '\033[0;36m  Script: 403.Check_Sudo_Access.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0403\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security\033[0m'
echo -e '\033[0;36m  Description: Shows the current user sudo privileges\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v sudo &>/dev/null; then
    echo -e "${RED}  ERROR: sudo is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  Checking sudo privileges...${NC}"
echo ""
sudo -l

echo ""
echo -e "${GREEN}  SUCCESS: Sudo privileges displayed.${NC}"

echo ""
read -rp "Press Enter to exit..." _
