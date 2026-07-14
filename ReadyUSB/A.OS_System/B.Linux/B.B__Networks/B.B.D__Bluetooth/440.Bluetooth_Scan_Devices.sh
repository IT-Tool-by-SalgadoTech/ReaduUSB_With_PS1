#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 440.Bluetooth_Scan_Devices.sh
# ScriptID: ST-LIN-0440
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > Bluetooth
# Description: Scans for nearby Bluetooth devices for 10 seconds.
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
echo -e '\033[0;36m  Script: 440.Bluetooth_Scan_Devices.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0440\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > Bluetooth\033[0m'
echo -e '\033[0;36m  Description: Scans for nearby Bluetooth devices for 10 seconds\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v bluetoothctl &>/dev/null; then
    echo -e "${RED}  ERROR: bluetoothctl is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  Scanning for nearby Bluetooth devices (10 seconds)...${NC}"
bluetoothctl --timeout 10 scan on

echo ""
read -rp "Press Enter to exit..." _
