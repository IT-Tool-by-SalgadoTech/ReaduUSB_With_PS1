#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 615.Download_and_install_Rusk_Desk.sh
# ScriptID: ST-LIN-0615
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux
# Description: Downloads the latest RustDesk release and installs it.
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
echo -e '\033[0;36m  Script: 615.Download_and_install_Rusk_Desk.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0615\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux\033[0m'
echo -e '\033[0;36m  Description: Downloads the latest RustDesk release and installs it\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v curl &>/dev/null; then
    echo -e "${RED}  ERROR: curl is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi

API="https://api.github.com/repos/rustdesk/rustdesk/releases/latest"
DEST="/tmp/rustdesk_latest"

echo -e "${YELLOW}  Querying latest RustDesk release...${NC}"
case "$ID" in
    debian|ubuntu|kali|linuxmint)
        url=$(curl -fsSL "$API" | grep -oE 'https://github.com/rustdesk/rustdesk/releases/download/[^" ]+/rustdesk-[^" ]*\.(deb)' | grep -E '(amd64|x86_64)\.deb$' | head -n1)
        if [ -z "$url" ]; then
            echo -e "${RED}  ERROR: No amd64/x86_64 .deb found in the latest release.${NC}"
            echo ""
            read -rp "Press Enter to exit..." _
            exit 1
        fi
        echo -e "${YELLOW}  Downloading $url ...${NC}"
        curl -fL -o "${DEST}.deb" "$url" && apt install -y "${DEST}.deb"
        ;;
    fedora|rhel|centos|rocky|almalinux)
        url=$(curl -fsSL "$API" | grep -oE 'https://github.com/rustdesk/rustdesk/releases/download/[^" ]+/rustdesk-[^" ]*\.(rpm)' | grep -E '(x86_64)\.rpm$' | head -n1)
        if [ -z "$url" ]; then
            echo -e "${RED}  ERROR: No x86_64 .rpm found in the latest release.${NC}"
            echo ""
            read -rp "Press Enter to exit..." _
            exit 1
        fi
        echo -e "${YELLOW}  Downloading $url ...${NC}"
        curl -fL -o "${DEST}.rpm" "$url" && dnf install -y "${DEST}.rpm"
        ;;
    arch|manjaro|endeavouros)
        echo -e "${RED}  ERROR: RustDesk is not in the official Arch repos. Install it from the AUR (e.g. rustdesk-bin).${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
        ;;
    *)
        echo -e "${RED}  ERROR: Unsupported distro: $ID${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
        ;;
esac

if [ $? -eq 0 ] && command -v rustdesk &>/dev/null; then
    echo -e "${GREEN}  SUCCESS: RustDesk installed.${NC}"
else
    echo -e "${RED}  ERROR: RustDesk installation failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
