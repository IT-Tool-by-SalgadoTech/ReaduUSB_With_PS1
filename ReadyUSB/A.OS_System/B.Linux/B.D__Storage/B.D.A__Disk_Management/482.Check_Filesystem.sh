#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 484.Check_Filesystem.sh
# ScriptID: ST-LIN-0484
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage > Disk Management
# Description: Checks and repairs the filesystem on an unmounted partition.
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
echo -e '\033[0;36m  Script: 484.Check_Filesystem.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0484\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage > Disk Management\033[0m'
echo -e '\033[0;36m  Description: Checks and repairs the filesystem on an unmounted partition\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

lsblk
echo ""
read -rp "  Unmounted partition to check (e.g. sdb1): " d

if [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Partition cannot be empty.${NC}"
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

if mount | grep -q "^/dev/$d "; then
    echo -e "${RED}  ERROR: /dev/$d is mounted. Unmount it before checking.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Checking filesystem on /dev/$d...${NC}"
fsck -y "/dev/$d"

if [ $? -le 1 ]; then
    echo -e "${GREEN}  SUCCESS: Filesystem check on /dev/$d completed.${NC}"
else
    echo -e "${RED}  ERROR: Filesystem check on /dev/$d reported problems.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
