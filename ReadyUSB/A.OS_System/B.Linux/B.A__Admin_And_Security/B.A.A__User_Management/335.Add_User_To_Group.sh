#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 335_Add_User_To_Group.sh
# ScriptID: ST-LIN-0335
# Version: 1.1
# Date: 2025-05-22
# Category: Linux > Admin And Security > User Management
# Description: Adds an existing user to a specified group using usermod -aG.
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
echo -e '\033[0;36m  Script: 335_Add_User_To_Group.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0335\033[0m'
echo -e '\033[0;36m  Version: 1.1\033[0m'
echo -e '\033[0;36m  Date: 2025-05-22\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > User Management\033[0m'
echo -e '\033[0;36m  Description: Adds an existing user to a specified group using usermod -aG\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Username: " u
read -rp "  Group: " g

if [ -z "$u" ] || [ -z "$g" ]; then
    echo -e "${RED}  ERROR: Username and group cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! id "$u" &>/dev/null; then
    echo -e "${RED}  ERROR: User '$u' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! getent group "$g" &>/dev/null; then
    echo -e "${RED}  ERROR: Group '$g' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Adding '$u' to group '$g'...${NC}"
usermod -aG "$g" "$u"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: User '$u' has been added to group '$g'.${NC}"
    echo ""
    echo "  Current groups for '$u':"
    groups "$u"
else
    echo -e "${RED}  ERROR: Failed to add '$u' to group '$g'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
