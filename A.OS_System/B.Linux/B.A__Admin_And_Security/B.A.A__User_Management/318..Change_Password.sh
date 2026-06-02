#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 318_Change_Password.sh
# ScriptID: ST-LIN-0318
# Version: 1.1
# Date: 2025-05-22
# Category: Linux > Admin And Security > User Management
# Description: Prompts for a username and launches an interactive password change using passwd.
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
echo -e '\033[0;36m  Script: 318_Change_Password.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0318\033[0m'
echo -e '\033[0;36m  Version: 1.1\033[0m'
echo -e '\033[0;36m  Date: 2025-05-22\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > User Management\033[0m'
echo -e '\033[0;36m  Description: Prompts for a username and launches an interactive password change using passwd\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Username: " u

if [ -z "$u" ]; then
    echo -e "${RED}  ERROR: Username cannot be empty.${NC}"
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

echo ""
echo -e "${YELLOW}  Setting new password for '$u'...${NC}"
passwd "$u"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Password for '$u' has been updated.${NC}"
else
    echo -e "${RED}  ERROR: Password change failed for '$u'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
