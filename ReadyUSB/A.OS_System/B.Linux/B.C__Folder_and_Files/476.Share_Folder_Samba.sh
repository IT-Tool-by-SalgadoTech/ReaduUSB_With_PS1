#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 476.Share_Folder_Samba.sh
# ScriptID: ST-LIN-0476
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files
# Description: Shares a folder via Samba with a basic configuration.
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
echo -e '\033[0;36m  Script: 476.Share_Folder_Samba.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0476\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files\033[0m'
echo -e '\033[0;36m  Description: Shares a folder via Samba with a basic configuration\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Folder to share: " dir
read -rp "  Share name: " sname
read -rp "  Samba username: " u

if [ -z "$dir" ] || [ -z "$sname" ] || [ -z "$u" ]; then
    echo -e "${RED}  ERROR: Folder, share name and username cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -d "$dir" ]; then
    echo -e "${RED}  ERROR: Directory '$dir' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! id "$u" &>/dev/null; then
    echo -e "${RED}  ERROR: System user '$u' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi
case "$ID" in
    debian|ubuntu|kali|linuxmint)
        SVC="smbd"
        command -v smbd &>/dev/null || { apt update && apt install -y samba; }
        ;;
    fedora|rhel|centos|rocky|almalinux)
        SVC="smb"
        command -v smbd &>/dev/null || dnf install -y samba
        ;;
    arch|manjaro|endeavouros)
        SVC="smb"
        command -v smbd &>/dev/null || pacman -Sy --noconfirm samba
        ;;
    *)
        echo -e "${RED}  ERROR: Unsupported distro: $ID${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
        ;;
esac

echo ""
echo -e "${YELLOW}  Adding share '[$sname]' to /etc/samba/smb.conf...${NC}"
printf '[%s]\n   path = %s\n   browseable = yes\n   writable = yes\n   valid users = %s\n' "$sname" "$dir" "$u" | tee -a /etc/samba/smb.conf >/dev/null

echo ""
echo -e "${YELLOW}  Setting Samba password for '$u'...${NC}"
smbpasswd -a "$u"

echo ""
echo -e "${YELLOW}  Restarting Samba service ($SVC)...${NC}"
systemctl restart "$SVC"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Samba share '$sname' created for folder '$dir'.${NC}"
else
    echo -e "${RED}  ERROR: Failed to restart Samba service.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
