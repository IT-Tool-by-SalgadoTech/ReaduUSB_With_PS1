#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 448.Flush_DNS_Cache.sh
# ScriptID: ST-LIN-0448
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks
# Description: Flushes the local DNS cache (systemd-resolved or nscd).
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
echo -e '\033[0;36m  Script: 448.Flush_DNS_Cache.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0448\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks\033[0m'
echo -e '\033[0;36m  Description: Flushes the local DNS cache (systemd-resolved or nscd)\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Flushing DNS cache...${NC}"

if command -v resolvectl &>/dev/null; then
    resolvectl flush-caches
    ok=$?
elif command -v systemd-resolve &>/dev/null; then
    systemd-resolve --flush-caches
    ok=$?
elif command -v service &>/dev/null; then
    service nscd restart 2>/dev/null
    ok=$?
else
    ok=1
fi

if [ "$ok" -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: DNS cache flushed.${NC}"
else
    echo -e "${RED}  ERROR: Could not flush DNS cache (no supported resolver found).${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
