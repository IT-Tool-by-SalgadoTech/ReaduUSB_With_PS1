#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 422.SSH_Generate_Key.sh
# ScriptID: ST-LIN-0422
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > SSH
# Description: Generates a new SSH RSA key pair (4096 bits).
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
echo -e '\033[0;36m  Script: 422.SSH_Generate_Key.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0422\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > SSH\033[0m'
echo -e '\033[0;36m  Description: Generates a new SSH RSA key pair (4096 bits)\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v ssh-keygen &>/dev/null; then
    echo -e "${RED}  ERROR: ssh-keygen is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Key filename (Enter for default ~/.ssh/id_rsa): " f

echo ""
echo -e "${YELLOW}  Generating RSA 4096-bit key pair...${NC}"
if [ -n "$f" ]; then
    ssh-keygen -t rsa -b 4096 -f "$f"
else
    ssh-keygen -t rsa -b 4096
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: SSH key pair generated.${NC}"
else
    echo -e "${RED}  ERROR: Failed to generate the SSH key pair.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
