#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 480.Create_Partition_Table.sh
# ScriptID: ST-LIN-0480
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage > Disk Management
# Description: Creates a new GPT partition table on a disk (DESTRUCTIVE).
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
echo -e '\033[0;36m  Script: 480.Create_Partition_Table.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0480\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage > Disk Management\033[0m'
echo -e '\033[0;36m  Description: Creates a new GPT partition table on a disk (DESTRUCTIVE)\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${RED}  WARNING: This will ERASE ALL DATA on the selected disk. This is IRREVERSIBLE.${NC}"
echo ""
lsblk
echo ""
read -rp "  Disk to partition (e.g. sdb - NOT a partition!): " d

if [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Disk cannot be empty.${NC}"
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

read -rp "  Type WIPE $d to confirm: " c

if [ "$c" != "WIPE $d" ]; then
    echo -e "${YELLOW}  Aborted. No changes were made.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Creating GPT partition table on /dev/$d...${NC}"
parted "/dev/$d" mklabel gpt

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: GPT table created on /dev/$d.${NC}"
else
    echo -e "${RED}  ERROR: Failed to create GPT table on /dev/$d.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
