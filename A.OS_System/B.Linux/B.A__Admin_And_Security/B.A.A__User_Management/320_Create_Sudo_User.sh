#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 320_Create_Sudo_User.sh
# ScriptID: ST-LIN-0320
# Version: 1.1
# Date: 2025-05-22
# Category: Linux > Admin And Security > User Management
# Description: Creates a new local user with a home directory and bash shell, sets their password interactively, and adds them to the admin group (sudo on Debian/Ubuntu/Kali, wheel on Arch/Fedora).
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

# Detect distro and set admin group
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
echo "  Create Sudo User"
echo "  -----------------"
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
