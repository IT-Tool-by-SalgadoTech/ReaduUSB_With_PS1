#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 449.Network_Speed_Test.sh
# ScriptID: ST-LIN-0449
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks
# Description: Runs a CLI internet speed test using speedtest-cli.
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
echo -e '\033[0;36m  Script: 449.Network_Speed_Test.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0449\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks\033[0m'
echo -e '\033[0;36m  Description: Runs a CLI internet speed test using speedtest-cli\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Running speed test...${NC}"
echo ""
if command -v speedtest-cli &>/dev/null; then
    speedtest-cli
elif python3 -c "import speedtest" &>/dev/null; then
    python3 -m speedtest
else
    echo -e "${RED}  ERROR: speedtest-cli is not installed.${NC}"
    echo -e "${YELLOW}  Install it with your package manager (package: speedtest-cli) or: pip install speedtest-cli${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
read -rp "Press Enter to exit..." _
