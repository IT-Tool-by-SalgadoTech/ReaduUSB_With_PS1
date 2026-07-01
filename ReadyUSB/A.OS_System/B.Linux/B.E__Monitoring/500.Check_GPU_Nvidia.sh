#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 500.Check_GPU_Nvidia.sh
# ScriptID: ST-LIN-0500
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Monitoring
# Description: Shows Nvidia GPU status and usage via nvidia-smi.
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
echo -e '\033[0;36m  Script: 500.Check_GPU_Nvidia.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0500\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Monitoring\033[0m'
echo -e '\033[0;36m  Description: Shows Nvidia GPU status and usage via nvidia-smi\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if command -v nvidia-smi &>/dev/null; then
    echo -e "${YELLOW}  Querying Nvidia GPU...${NC}"
    echo ""
    nvidia-smi
else
    echo -e "${RED}  nvidia-smi not found. NVIDIA drivers may not be installed.${NC}"
    echo -e "${YELLOW}  Install the NVIDIA driver package for your distro to enable this.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
