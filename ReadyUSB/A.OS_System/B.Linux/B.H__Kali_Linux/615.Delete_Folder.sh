#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 615.Delete_Folder.sh
# ScriptID: ST-LIN-0615
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux
# Description: Recursively deletes a folder at a given path after confirmation.
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
echo -e '\033[0;36m  Script: 615.Delete_Folder.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0615\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux\033[0m'
echo -e '\033[0;36m  Description: Recursively deletes a folder at a given path after confirmation\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Path to delete: " path

if [ -z "$path" ]; then
    echo -e "${RED}  ERROR: Path cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

path="${path/#\~/$HOME}"

if [ ! -e "$path" ]; then
    echo -e "${RED}  ERROR: '$path' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ "$path" = "/" ]; then
    echo -e "${RED}  ERROR: Refusing to delete '/'.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${RED}  WARNING: This will permanently delete '$path' and all its contents.${NC}"
read -rp "  Type DELETE to confirm: " c

if [ "$c" != "DELETE" ]; then
    echo -e "${YELLOW}  Aborted. Nothing was deleted.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Deleting '$path'...${NC}"
rm -rf "$path"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: '$path' deleted.${NC}"
else
    echo -e "${RED}  ERROR: Failed to delete '$path'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
