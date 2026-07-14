#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 460.Set_Immutable.sh
# ScriptID: ST-LIN-0460
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files > Permissions
# Description: Sets a file as immutable using chattr +i.
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
echo -e '\033[0;36m  Script: 460.Set_Immutable.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0460\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files > Permissions\033[0m'
echo -e '\033[0;36m  Description: Sets a file as immutable using chattr +i\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  File path: " f

if [ -z "$f" ]; then
    echo -e "${RED}  ERROR: File path cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -e "$f" ]; then
    echo -e "${RED}  ERROR: File '$f' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Setting '$f' as immutable...${NC}"
chattr +i "$f"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: '$f' set as immutable.${NC}"
    echo ""
    echo "  Current attributes:"
    lsattr "$f"
else
    echo -e "${RED}  ERROR: Failed to set '$f' as immutable.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
