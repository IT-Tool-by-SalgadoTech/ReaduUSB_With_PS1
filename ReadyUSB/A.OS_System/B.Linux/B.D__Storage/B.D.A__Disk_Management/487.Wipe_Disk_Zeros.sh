#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 487.Wipe_Disk_Zeros.sh
# ScriptID: ST-LIN-0487
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage > Disk Management
# Description: Securely wipes a disk by writing zeros (SLOW, DESTRUCTIVE).
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
echo -e '\033[0;36m  Script: 487.Wipe_Disk_Zeros.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0487\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage > Disk Management\033[0m'
echo -e '\033[0;36m  Description: Securely wipes a disk by writing zeros (SLOW, DESTRUCTIVE)\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${RED}  WARNING: This will OVERWRITE the entire disk with zeros. ALL DATA WILL BE LOST.${NC}"
echo -e "${RED}  This operation is IRREVERSIBLE and can take a very long time.${NC}"
echo ""
lsblk
echo ""
read -rp "  Disk/partition to wipe (e.g. sdb): " d

if [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Disk/partition cannot be empty.${NC}"
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
    echo -e "${RED}  ERROR: /dev/$d is mounted. Unmount it before wiping.${NC}"
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
echo -e "${YELLOW}  Wiping /dev/$d with zeros...${NC}"
dd if=/dev/zero of="/dev/$d" bs=4M status=progress

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Disk /dev/$d wiped.${NC}"
else
    echo -e "${RED}  ERROR: Failed to wipe /dev/$d.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
