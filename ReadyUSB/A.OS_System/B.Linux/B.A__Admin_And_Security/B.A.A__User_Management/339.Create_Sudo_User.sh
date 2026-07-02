#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 339_Create_Sudo_User.sh
# ScriptID: ST-LIN-0339
# Version: 1.1
# Date: 2025-05-22
# Category: Linux > Admin And Security > User Management
# Description: Creates a new user with home directory and bash shell, sets password, adds to admin group (sudo/wheel based on distro).
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

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID"
else
    DISTRO="unknown"
fi

case "$DISTRO" in
    ubuntu|debian|linuxmint|kali) ADMIN_GROUP="sudo" ;;
    arch|manjaro|endeavouros)     ADMIN_GROUP="wheel" ;;
    fedora|rhel|centos|rocky|almalinux) ADMIN_GROUP="wheel" ;;
    *)                            ADMIN_GROUP="sudo" ;;
esac

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
echo -e '\033[0;36m  Script: 339_Create_Sudo_User.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0339\033[0m'
echo -e '\033[0;36m  Version: 1.1\033[0m'
echo -e '\033[0;36m  Date: 2025-05-22\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > User Management\033[0m'
echo -e '\033[0;36m  Description: Creates a new user with home directory and bash shell, sets password, adds to admin group\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "  Detected distro : ${YELLOW}$DISTRO${NC}"
echo -e "  Admin group     : ${YELLOW}$ADMIN_GROUP${NC}"
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
if [ $? -ne 0 ]; then
    echo -e "${RED}  ERROR: Failed to set password for '$u'.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

usermod -aG "$ADMIN_GROUP" "$u"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: User '$u' created and added to '$ADMIN_GROUP' group.${NC}"
    echo ""
    echo "  Current groups for '$u':"
    groups "$u"
else
    echo -e "${RED}  ERROR: User created but failed to add to '$ADMIN_GROUP' group.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
