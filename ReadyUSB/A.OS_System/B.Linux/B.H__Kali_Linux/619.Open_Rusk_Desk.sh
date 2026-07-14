#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 619.Open_Rusk_Desk.sh
# ScriptID: ST-LIN-0619
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux
# Description: Launches the RustDesk remote desktop application.
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
echo -e '\033[0;36m  Script: 619.Open_Rusk_Desk.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0619\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux\033[0m'
echo -e '\033[0;36m  Description: Launches the RustDesk remote desktop application\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v rustdesk &>/dev/null; then
    echo -e "${RED}  ERROR: RustDesk is not installed. Run the install script first.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  Launching RustDesk...${NC}"
rustdesk &

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: RustDesk started.${NC}"
else
    echo -e "${RED}  ERROR: Failed to launch RustDesk.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
