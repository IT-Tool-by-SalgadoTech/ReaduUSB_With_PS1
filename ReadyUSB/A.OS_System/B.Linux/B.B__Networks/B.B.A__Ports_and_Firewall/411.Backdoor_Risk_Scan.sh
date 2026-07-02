#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 411.Backdoor_Risk_Scan.sh
# ScriptID: ST-LIN-0411
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > Ports And Firewall
# Description: Scans for suspicious listening ports, outbound connections and autostart services.
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
echo -e '\033[0;36m  Script: 411.Backdoor_Risk_Scan.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0411\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > Ports And Firewall\033[0m'
echo -e '\033[0;36m  Description: Scans for suspicious listening ports, outbound connections and autostart services\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v ss &>/dev/null; then
    echo -e "${RED}  ERROR: ss is not installed (package iproute2).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  === Listening Ports ===${NC}"
ss -tlnp
echo ""
echo -e "${YELLOW}  === Established Outbound ===${NC}"
ss -tnp state established | grep -v "127.0.0.1\|::1"
echo ""
echo -e "${YELLOW}  === Unusual Autostart Services ===${NC}"
if command -v systemctl &>/dev/null; then
    systemctl list-unit-files --type=service --state=enabled 2>/dev/null | grep -Ev "NetworkManager|ssh|cron|ufw|systemd|getty|dbus|accounts|gdm|lightdm|cups"
else
    echo -e "${RED}  systemctl not available; cannot list autostart services.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
