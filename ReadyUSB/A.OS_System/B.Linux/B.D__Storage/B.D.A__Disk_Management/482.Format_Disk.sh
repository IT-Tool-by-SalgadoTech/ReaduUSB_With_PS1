#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 482.Format_Disk.sh
# ScriptID: ST-LIN-0482
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage > Disk Management
# Description: Formats a partition with a chosen filesystem (DESTRUCTIVE).
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
echo -e '\033[0;36m  Script: 482.Format_Disk.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0482\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage > Disk Management\033[0m'
echo -e '\033[0;36m  Description: Formats a partition with a chosen filesystem (DESTRUCTIVE)\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${RED}  WARNING: This will ERASE ALL DATA on the selected partition. This is IRREVERSIBLE.${NC}"
echo ""
lsblk
echo ""
read -rp "  Partition to format (e.g. sdb1): " d
read -rp "  Filesystem (ext4/ntfs/fat32/exfat): " fs

if [ -z "$d" ] || [ -z "$fs" ]; then
    echo -e "${RED}  ERROR: Partition and filesystem cannot be empty.${NC}"
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

if ! command -v "mkfs.$fs" &>/dev/null; then
    echo -e "${RED}  ERROR: mkfs.$fs is not available for filesystem '$fs'.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if mount | grep -q "^/dev/$d "; then
    echo -e "${RED}  ERROR: /dev/$d is mounted. Unmount it before formatting.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Type FORMAT $d to confirm: " c

if [ "$c" != "FORMAT $d" ]; then
    echo -e "${YELLOW}  Aborted. No changes were made.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Formatting /dev/$d as $fs...${NC}"
"mkfs.$fs" "/dev/$d"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Partition /dev/$d formatted as $fs.${NC}"
else
    echo -e "${RED}  ERROR: Failed to format /dev/$d as $fs.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
