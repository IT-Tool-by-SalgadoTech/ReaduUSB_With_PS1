#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 489.Disk_Info.sh
# ScriptID: ST-LIN-0489
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage
# Description: Shows detailed disk information (model, serial, health).
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
echo -e '\033[0;36m  Script: 489.Disk_Info.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0489\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage\033[0m'
echo -e '\033[0;36m  Description: Shows detailed disk information (model, serial, health)\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Disk device (e.g. sda, nvme0n1): " d

if [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Disk device cannot be empty.${NC}"
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

echo ""
echo -e "${YELLOW}  Reading information for /dev/$d...${NC}"
if hdparm -I "/dev/$d" 2>/dev/null | head -20; then
    echo -e "${GREEN}  SUCCESS: Disk information for /dev/$d displayed.${NC}"
else
    lshw -class disk 2>/dev/null | head -30
    echo -e "${GREEN}  SUCCESS: Disk information displayed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
