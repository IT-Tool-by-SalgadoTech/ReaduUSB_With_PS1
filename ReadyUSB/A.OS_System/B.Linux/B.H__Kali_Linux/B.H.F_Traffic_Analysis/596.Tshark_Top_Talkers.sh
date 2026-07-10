#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 596.Tshark_Top_Talkers.sh
# ScriptID: ST-LIN-0596
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Traffic Analysis
# Description: Shows top IP conversations by packet count from a pcap file using tshark.
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
echo -e '\033[0;36m  Script: 596.Tshark_Top_Talkers.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0596\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Traffic Analysis\033[0m'
echo -e '\033[0;36m  Description: Shows top IP conversations by packet count from a pcap file using tshark\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v tshark &>/dev/null; then
    echo -e "${RED}  ERROR: tshark is not installed. Run: apt install tshark${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  PCAP file path: " f
if [ -z "$f" ]; then
    echo -e "${RED}  ERROR: PCAP file path cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -f "$f" ]; then
    echo -e "${RED}  ERROR: File '$f' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Analyzing '$f'...${NC}"
tshark -r "$f" -q -z conv,ip | head -20

echo ""
read -rp "Press Enter to exit..." _
