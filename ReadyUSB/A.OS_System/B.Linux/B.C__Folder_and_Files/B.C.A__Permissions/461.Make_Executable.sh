#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 461.Make_Executable.sh
# ScriptID: ST-LIN-0461
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files > Permissions
# Description: Makes a file executable using chmod +x.
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
echo -e '\033[0;36m  Script: 461.Make_Executable.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0461\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files > Permissions\033[0m'
echo -e '\033[0;36m  Description: Makes a file executable using chmod +x\033[0m'
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
echo -e "${YELLOW}  Making '$f' executable...${NC}"
chmod +x "$f"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: '$f' is now executable.${NC}"
    echo ""
    echo "  Current permissions:"
    ls -l "$f"
else
    echo -e "${RED}  ERROR: Failed to make '$f' executable.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
