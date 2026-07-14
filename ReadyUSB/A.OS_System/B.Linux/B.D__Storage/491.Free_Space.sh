#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 491.Free_Space.sh
# ScriptID: ST-LIN-0491
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage
# Description: Shows free disk space on all mounted filesystems.
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
echo -e '\033[0;36m  Script: 491.Free_Space.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0491\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage\033[0m'
echo -e '\033[0;36m  Description: Shows free disk space on all mounted filesystems\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Reading free space on mounted filesystems...${NC}"
df -hT | grep -v tmpfs

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Free space displayed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to read filesystem usage.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
