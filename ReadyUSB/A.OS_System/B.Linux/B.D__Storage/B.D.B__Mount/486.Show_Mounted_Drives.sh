#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 486.Show_Mounted_Drives.sh
# ScriptID: ST-LIN-0486
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage > Mount
# Description: Shows all currently mounted drives and filesystems.
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
echo -e '\033[0;36m  Script: 486.Show_Mounted_Drives.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0486\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage > Mount\033[0m'
echo -e '\033[0;36m  Description: Shows all currently mounted drives and filesystems\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Listing mounted drives and filesystems...${NC}"
mount | grep -v "tmpfs\|sysfs\|proc\|devpts\|cgroup\|mqueue\|hugetlb\|pstore\|bpf\|tracefs"

echo -e "${GREEN}  SUCCESS: Mounted drives displayed.${NC}"

echo ""
read -rp "Press Enter to exit..." _
