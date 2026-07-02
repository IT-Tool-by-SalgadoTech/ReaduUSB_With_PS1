#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 487.Auto_Mount_fstab.sh
# ScriptID: ST-LIN-0487
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage > Mount
# Description: Adds a partition to /etc/fstab for auto-mount on boot.
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
echo -e '\033[0;36m  Script: 487.Auto_Mount_fstab.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0487\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage > Mount\033[0m'
echo -e '\033[0;36m  Description: Adds a partition to /etc/fstab for auto-mount on boot\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

lsblk -o NAME,UUID,FSTYPE
echo ""
read -rp "  UUID of partition: " uuid
read -rp "  Mount point (e.g. /mnt/data): " mp
read -rp "  Filesystem type (ext4/ntfs/vfat): " fs

if [ -z "$uuid" ] || [ -z "$mp" ] || [ -z "$fs" ]; then
    echo -e "${RED}  ERROR: UUID, mount point and filesystem type cannot be empty.${NC}"
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
echo -e "${YELLOW}  Creating mount point '$mp' and adding fstab entry...${NC}"
mkdir -p "$mp"
echo "UUID=$uuid $mp $fs defaults 0 2" | tee -a /etc/fstab

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Entry added to /etc/fstab.${NC}"
else
    echo -e "${RED}  ERROR: Failed to add entry to /etc/fstab.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
