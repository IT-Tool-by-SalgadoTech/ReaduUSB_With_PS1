#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 438.Bluetooth_Remove_Device.sh
# ScriptID: ST-LIN-0438
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > Bluetooth
# Description: Removes or unpairs a Bluetooth device by MAC address.
# (c) 2025 SalgadoTech - All Rights Reserved
# Unauthorized distribution prohibited
# ==============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "\033[0;31m  ERROR: This script requires root privileges.\033[0m"
    echo -e "\033[1;33m  Run with: sudo bash $(basename "$0")\033[0m"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

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
echo -e '\033[0;36m  Script: 438.Bluetooth_Remove_Device.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0438\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > Bluetooth\033[0m'
echo -e '\033[0;36m  Description: Removes or unpairs a Bluetooth device by MAC address\033[0m'
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

read -rp "  Device MAC to remove: " mac

if [ -z "$mac" ]; then
    echo -e "${RED}  ERROR: MAC address cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! echo "$mac" | grep -qiE '^([0-9A-F]{2}:){5}[0-9A-F]{2}$'; then
    echo -e "${RED}  ERROR: Invalid MAC address format.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Removing '$mac'...${NC}"
bluetoothctl remove "$mac"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Device '$mac' removed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to remove '$mac'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
