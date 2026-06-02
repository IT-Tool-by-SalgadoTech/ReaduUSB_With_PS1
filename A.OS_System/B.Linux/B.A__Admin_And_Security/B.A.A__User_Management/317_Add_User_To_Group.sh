#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 317_Add_User_To_Group.sh
# ScriptID: ST-LIN-0317
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
echo "  Add User To Group"
echo "  ------------------"
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
