#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 508.System_Info_Full.sh
# ScriptID: ST-LIN-0508
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Monitoring
# Description: Shows full system info (OS, kernel, CPU, RAM, disk).
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
echo -e '\033[0;36m  Script: 508.System_Info_Full.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0508\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Monitoring\033[0m'
echo -e '\033[0;36m  Description: Shows full system info (OS, kernel, CPU, RAM, disk)\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo "  === OS ==="
grep -E "^NAME|^VERSION" /etc/os-release 2>/dev/null
echo ""
echo "  === Kernel ==="
uname -a
echo ""
echo "  === CPU ==="
lscpu | grep -E "Model name|Cores|Thread"
echo ""
echo "  === RAM ==="
free -h
echo ""
echo "  === Disk ==="
df -h | grep -v tmpfs

echo ""
read -rp "Press Enter to exit..." _
