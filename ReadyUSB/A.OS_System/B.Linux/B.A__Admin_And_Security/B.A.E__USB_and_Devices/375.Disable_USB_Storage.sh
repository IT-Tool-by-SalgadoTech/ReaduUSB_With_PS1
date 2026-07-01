#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 375.Disable_USB_Storage.sh
# ScriptID: ST-LIN-0375
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > USB And Devices
# Description: Disables the USB mass storage module to block USB drives.
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
echo -e '\033[0;36m  Script: 375.Disable_USB_Storage.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0375\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > USB And Devices\033[0m'
echo -e '\033[0;36m  Description: Disables the USB mass storage module to block USB drives\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  This will unload the usb_storage module and block USB drives from mounting.${NC}"
read -rp "  Type DISABLE to confirm: " c

if [ "$c" != "DISABLE" ]; then
    echo -e "${YELLOW}  Aborted. USB storage was not changed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Disabling USB storage module...${NC}"
modprobe -r usb_storage

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: USB storage disabled.${NC}"
else
    echo -e "${RED}  ERROR: Failed to disable USB storage (module in use or not loaded).${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
