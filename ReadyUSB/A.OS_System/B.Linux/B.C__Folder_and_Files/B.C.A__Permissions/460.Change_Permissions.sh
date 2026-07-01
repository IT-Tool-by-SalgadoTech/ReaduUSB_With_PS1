#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 460.Change_Permissions.sh
# ScriptID: ST-LIN-0460
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files > Permissions
# Description: Changes file or folder permissions recursively using chmod.
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
echo -e '\033[0;36m  Script: 460.Change_Permissions.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0460\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files > Permissions\033[0m'
echo -e '\033[0;36m  Description: Changes file or folder permissions recursively using chmod\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  File/folder path: " f
read -rp "  Permissions (e.g. 755, 644, 777): " perm

if [ -z "$f" ] || [ -z "$perm" ]; then
    echo -e "${RED}  ERROR: Path and permissions cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -e "$f" ]; then
    echo -e "${RED}  ERROR: Path '$f' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! [[ "$perm" =~ ^[0-7]{3,4}$ ]]; then
    echo -e "${RED}  ERROR: '$perm' is not a valid octal permission (e.g. 755).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Applying permissions '$perm' to '$f'...${NC}"
chmod -R "$perm" "$f"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Permissions of '$f' set to '$perm'.${NC}"
    echo ""
    echo "  Current permissions:"
    ls -ld "$f"
else
    echo -e "${RED}  ERROR: Failed to change permissions of '$f'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
