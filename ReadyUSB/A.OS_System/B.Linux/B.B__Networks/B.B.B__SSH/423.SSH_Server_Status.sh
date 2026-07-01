#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 425.SSH_Server_Status.sh
# ScriptID: ST-LIN-0425
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > SSH
# Description: Checks the SSH server status and its listening port.
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
echo -e '\033[0;36m  Script: 425.SSH_Server_Status.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0425\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > SSH\033[0m'
echo -e '\033[0;36m  Description: Checks SSH server status and listening port\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi
case "$ID" in
    debian|ubuntu|kali|linuxmint) SVC="ssh" ;;
    *) SVC="sshd" ;;
esac

echo -e "${YELLOW}  SSH service status:${NC}"
systemctl status "$SVC" --no-pager
echo ""
echo -e "${YELLOW}  Listening sshd ports:${NC}"
ss -tlnp | grep sshd || echo "  (not listening)"

echo ""
read -rp "Press Enter to exit..." _
