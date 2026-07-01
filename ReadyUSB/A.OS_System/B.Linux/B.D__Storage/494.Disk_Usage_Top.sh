#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 494.Disk_Usage_Top.sh
# ScriptID: ST-LIN-0494
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage
# Description: Shows the top 20 largest directories from root.
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
echo -e '\033[0;36m  Script: 494.Disk_Usage_Top.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0494\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage\033[0m'
echo -e '\033[0;36m  Description: Shows the top 20 largest directories from root\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Scanning filesystem for the 20 largest directories...${NC}"
du -xh / --max-depth=3 2>/dev/null | sort -rh | head -20

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Top directories displayed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to compute disk usage.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
