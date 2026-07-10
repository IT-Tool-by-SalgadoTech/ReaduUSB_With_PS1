#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 491.Show_Disks.sh
# ScriptID: ST-LIN-0491
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage
# Description: Shows all disks and partitions with sizes and filesystems.
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
echo -e '\033[0;36m  Script: 491.Show_Disks.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0491\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage\033[0m'
echo -e '\033[0;36m  Description: Shows all disks and partitions with sizes and filesystems\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Listing disks and partitions...${NC}"
lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINT,UUID

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Disks and partitions displayed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to list block devices.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
