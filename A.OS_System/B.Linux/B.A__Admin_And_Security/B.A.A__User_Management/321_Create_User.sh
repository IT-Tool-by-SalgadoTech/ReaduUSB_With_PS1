#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 321_Create_User.sh
# ScriptID: ST-LIN-0321
# Version: 1.1
# Date: 2025-05-22
# Category: Linux > Admin And Security > User Management
# Description: Creates a new standard local user with home directory and bash shell, sets password interactively.
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
echo -e '\033[0;36m  Script: 321_Create_User.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0321\033[0m'
echo -e '\033[0;36m  Version: 1.1\033[0m'
echo -e '\033[0;36m  Date: 2025-05-22\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > User Management\033[0m'
echo -e '\033[0;36m  Description: Creates a new standard local user with home directory and bash shell, sets password interactively\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  New username: " u

if [ -z "$u" ]; then
    echo -e "${RED}  ERROR: Username cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if id "$u" &>/dev/null; then
    echo -e "${RED}  ERROR: User '$u' already exists.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Creating user '$u'...${NC}"
useradd -m -s /bin/bash "$u"
if [ $? -ne 0 ]; then
    echo -e "${RED}  ERROR: Failed to create user '$u'.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  Set password for '$u':${NC}"
passwd "$u"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: User '$u' has been created.${NC}"
else
    echo -e "${RED}  ERROR: User created but failed to set password.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
