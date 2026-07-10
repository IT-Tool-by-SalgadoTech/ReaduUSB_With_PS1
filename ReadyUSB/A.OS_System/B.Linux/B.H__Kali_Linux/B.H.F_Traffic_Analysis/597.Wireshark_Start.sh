#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 597.Wireshark_Start.sh
# ScriptID: ST-LIN-0597
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Traffic Analysis
# Description: Launches the Wireshark GUI packet analyzer (requires a graphical display).
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
echo -e '\033[0;36m  Script: 597.Wireshark_Start.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0597\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Traffic Analysis\033[0m'
echo -e '\033[0;36m  Description: Launches the Wireshark GUI packet analyzer (requires a graphical display)\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v wireshark &>/dev/null; then
    echo -e "${RED}  ERROR: Wireshark is not installed. Run: apt install wireshark${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ -z "$DISPLAY" ]; then
    echo -e "${RED}  ERROR: No graphical display detected (DISPLAY is not set).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  Launching Wireshark...${NC}"
wireshark >/dev/null 2>&1 &
echo -e "${GREEN}  SUCCESS: Wireshark launched.${NC}"

echo ""
read -rp "Press Enter to exit..." _
