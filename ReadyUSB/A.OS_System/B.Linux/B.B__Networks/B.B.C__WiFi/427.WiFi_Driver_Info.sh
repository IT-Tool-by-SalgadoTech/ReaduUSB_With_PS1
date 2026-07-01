#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 429.WiFi_Driver_Info.sh
# ScriptID: ST-LIN-0429
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > WiFi
# Description: Shows WiFi adapter driver and hardware information.
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
echo -e '\033[0;36m  Script: 429.WiFi_Driver_Info.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0429\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > WiFi\033[0m'
echo -e '\033[0;36m  Description: Shows WiFi adapter driver and hardware info\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  PCI wireless devices:${NC}"
if command -v lspci &>/dev/null; then
    lspci | grep -i wireless || echo "  (none found)"
else
    echo "  (lspci not available)"
fi

echo ""
echo -e "${YELLOW}  USB wireless devices:${NC}"
if command -v lsusb &>/dev/null; then
    lsusb | grep -i wireless || echo "  (none found)"
else
    echo "  (lsusb not available)"
fi

echo ""
echo -e "${YELLOW}  Wireless interfaces:${NC}"
if command -v iwconfig &>/dev/null; then
    iwconfig 2>/dev/null | grep -v "no wireless" || echo "  (none found)"
else
    echo "  (iwconfig not available)"
fi

echo ""
read -rp "Press Enter to exit..." _
