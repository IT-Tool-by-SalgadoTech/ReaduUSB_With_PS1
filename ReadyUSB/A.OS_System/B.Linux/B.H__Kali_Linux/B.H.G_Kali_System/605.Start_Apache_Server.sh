#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 605.Start_Apache_Server.sh
# ScriptID: ST-LIN-0605
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Kali System
# Description: Starts the Apache web server to host files for transfers.
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
echo -e '\033[0;36m  Script: 605.Start_Apache_Server.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0605\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Kali System\033[0m'
echo -e '\033[0;36m  Description: Starts the Apache web server to host files for transfers\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi

case "$ID" in
    debian|ubuntu|kali|linuxmint)
        service="apache2"; docroot="/var/www/html"
        ;;
    fedora|rhel|centos|rocky|almalinux|arch|manjaro|endeavouros)
        service="httpd"; docroot="/srv/http (arch) or /var/www/html (fedora)"
        ;;
    *)
        echo -e "${RED}  ERROR: Unsupported distro: $ID${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
        ;;
esac

echo -e "${YELLOW}  Starting $service...${NC}"
systemctl start "$service"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Apache ($service) started. Serving from $docroot${NC}"
    ss -tlnp | grep -Ei 'apache|httpd'
else
    echo -e "${RED}  ERROR: Failed to start $service.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
