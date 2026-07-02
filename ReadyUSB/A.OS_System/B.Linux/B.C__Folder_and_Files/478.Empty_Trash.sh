#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 478.Empty_Trash.sh
# ScriptID: ST-LIN-0478
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files
# Description: Empties the current user trash.
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
echo -e '\033[0;36m  Script: 478.Empty_Trash.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0478\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files\033[0m'
echo -e '\033[0;36m  Description: Empties the current user trash\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Type EMPTY to confirm emptying the trash: " c

if [ "$c" != "EMPTY" ]; then
    echo -e "${YELLOW}  Aborted. No changes were made.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Emptying user trash...${NC}"
rm -rf "$HOME"/.local/share/Trash/files/* "$HOME"/.local/share/Trash/info/* 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Trash emptied.${NC}"
else
    echo -e "${RED}  ERROR: Failed to empty trash.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
