#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 319_Check_User_Groups.sh
# ScriptID: ST-LIN-0319
# Version: 1.1
# Date: 2025-05-22
# Category: Linux > Admin And Security > User Management
# Description: Prompts for a username and displays all groups that account belongs to.
# (c) 2025 SalgadoTech - All Rights Reserved
# Unauthorized distribution prohibited
# ==============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "  Check User Groups"
echo "  ------------------"
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
echo -e "${GREEN}  Groups for '$u':${NC}"
groups "$u"

echo ""
read -rp "Press Enter to exit..." _
