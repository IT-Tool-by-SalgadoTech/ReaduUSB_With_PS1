#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 466.Delete_Duplicate_Files.sh
# ScriptID: ST-LIN-0466
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files > Find And Search
# Description: Finds and lists duplicate files by hash using fdupes.
# (c) 2025 SalgadoTech - All Rights Reserved
# Unauthorized distribution prohibited
# ==============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

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
echo -e '\033[0;36m  Script: 466.Delete_Duplicate_Files.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0466\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files > Find And Search\033[0m'
echo -e '\033[0;36m  Description: Finds and lists duplicate files by hash using fdupes\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Directory to scan: " d

if [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Directory cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -d "$d" ]; then
    echo -e "${RED}  ERROR: Directory '$d' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! command -v fdupes &>/dev/null; then
    echo -e "${YELLOW}  fdupes is not installed. Installing...${NC}"
    if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi
    case "$ID" in
        debian|ubuntu|kali|linuxmint) apt update && apt install -y fdupes ;;
        fedora|rhel|centos|rocky|almalinux) dnf install -y fdupes ;;
        arch|manjaro|endeavouros) pacman -Sy --noconfirm fdupes ;;
        *)
            echo -e "${RED}  ERROR: Unsupported distro: $ID${NC}"
            echo ""
            read -rp "Press Enter to exit..." _
            exit 1
            ;;
    esac
fi

if ! command -v fdupes &>/dev/null; then
    echo -e "${RED}  ERROR: fdupes could not be installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Scanning '$d' for duplicate files...${NC}"
echo ""
fdupes -r "$d"

echo ""
read -rp "Press Enter to exit..." _
