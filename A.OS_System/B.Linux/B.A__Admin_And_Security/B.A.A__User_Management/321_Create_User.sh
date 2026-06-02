#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 321_Create_User.sh
# ScriptID: ST-LIN-0321
# Version: 1.1
# Date: 2025-05-22
# Category: Linux > Admin And Security > User Management
# Description: Creates a new standard local user with a home directory and bash shell, then sets their password interactively.
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
echo "  Create Standard User"
echo "  ---------------------"
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
