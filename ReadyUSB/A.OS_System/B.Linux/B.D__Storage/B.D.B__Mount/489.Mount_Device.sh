#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 489.Mount_Device.sh
# ScriptID: ST-LIN-0489
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage > Mount
# Description: Mounts a device to a folder.
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
echo -e '\033[0;36m  Script: 489.Mount_Device.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0489\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage > Mount\033[0m'
echo -e '\033[0;36m  Description: Mounts a device to a folder\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

lsblk
echo ""
read -rp "  Device to mount (e.g. sdb1): " d
read -rp "  Mount point (e.g. /mnt/usb): " mp

if [ -z "$d" ] || [ -z "$mp" ]; then
    echo -e "${RED}  ERROR: Device and mount point cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -b "/dev/$d" ]; then
    echo -e "${RED}  ERROR: Block device '/dev/$d' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

case "$mp" in
    /*) : ;;
    *)
        echo -e "${RED}  ERROR: Mount point must be an absolute path.${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1 ;;
esac

echo ""
echo -e "${YELLOW}  Mounting /dev/$d at $mp...${NC}"
mkdir -p "$mp" && mount "/dev/$d" "$mp"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Mounted /dev/$d at $mp.${NC}"
else
    echo -e "${RED}  ERROR: Failed to mount /dev/$d at $mp.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
