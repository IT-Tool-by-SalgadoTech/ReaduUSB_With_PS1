#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 569.SMB_Enum_Enum4linux.sh
# ScriptID: ST-LIN-0569
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Recon And OSINT
# Description: Enumerates SMB shares, users and groups on a host using enum4linux.
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
echo -e '\033[0;36m  Script: 569.SMB_Enum_Enum4linux.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0569\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Recon And OSINT\033[0m'
echo -e '\033[0;36m  Description: Enumerates SMB shares, users and groups on a host using enum4linux\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v enum4linux &>/dev/null; then
    echo -e "${RED}  ERROR: enum4linux is not installed. Run: sudo apt install enum4linux${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Target IP: " ip

if [ -z "$ip" ]; then
    echo -e "${RED}  ERROR: Target IP cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Enumerating SMB on '$ip'...${NC}"
enum4linux -a "$ip"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: SMB enumeration of '$ip' completed.${NC}"
else
    echo -e "${RED}  ERROR: SMB enumeration of '$ip' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
