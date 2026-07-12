#!/usr/bin/env bash
# ScriptID: ST-LIN-0656  |  660.Empty_content_any_folder.sh
# Clears every file and subfolder inside a folder without deleting the folder itself.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

# ---- ITTOOL HEADER ----
it_detect_distro
printf '\n'
printf '%s%s%s\n' "$C_CY" ' _____ _____  _______ ____   ____  _     ' "$C_RS"
printf '%s%s%s\n' "$C_CY" '|_   _|_   _||__   __/ __ \ / __ \| |    ' "$C_RS"
printf '%s%s%s\n' "$C_CY" '  | |   | |     | | | |  | | |  | | |    ' "$C_RS"
printf '%s%s%s\n' "$C_CY" '  | |   | |     | | | |  | | |  | | |    ' "$C_RS"
printf '%s%s%s\n' "$C_CY" ' _| |_  | |     | | | |__| | |__| | |___ ' "$C_RS"
printf '%s%s%s\n' "$C_CY" '|_____| |_|     |_|  \____/ \____/|_____|' "$C_RS"
printf '\n'
echo "${C_WH}  ==================================================================${C_RS}"
echo "${C_CY}  IT-Tool by SalgadoTech${C_RS}"
echo "${C_CY}  Script: 656.Empty_content_any_folder.sh${C_RS}"
echo "${C_CY}  ScriptID: ST-LIN-0656${C_RS}"
echo "${C_CY}  Version: 1.0${C_RS}"
echo "${C_CY}  Date: 2026-07-12${C_RS}"
echo "${C_CY}  Category: Linux > Folder & Files${C_RS}"
echo "${C_CY}  Description: Clears all contents of a folder, keeping the folder itself${C_RS}"
echo "${C_CY}  Detected OS: ${IT_DISTRO_PRETTY}  (family: ${IT_FAMILY}, pkg: ${IT_PKG:-none})${C_RS}"
echo "${C_CY}  (c) 2026 SalgadoTech - All Rights Reserved${C_RS}"
echo "${C_CY}  Unauthorized distribution prohibited${C_RS}"
echo "${C_WH}  ==================================================================${C_RS}"
echo ""
it_need_root "$@"

folder=$(it_ask "Enter full path of folder to clear: " "")
if [ -z "$folder" ]; then it_err "No folder path provided."; it_pause; exit 1; fi
if [ ! -d "$folder" ]; then it_err "Folder not found: '$folder'"; it_pause; exit 1; fi

# Resolve to an absolute, symlink-free path and refuse dangerous targets.
resolved="$(cd "$folder" 2>/dev/null && pwd -P)"
if [ -z "$resolved" ]; then it_err "Could not resolve '$folder'."; it_pause; exit 1; fi
case "$resolved" in
    /|/bin|/sbin|/lib|/lib64|/usr|/etc|/var|/boot|/dev|/proc|/sys|/run|/home|/root)
        it_err "Refusing to empty a critical system directory: '$resolved'"; it_pause; exit 1 ;;
esac

echo
it_warn "This will PERMANENTLY delete everything inside:"
it_warn "  $resolved"
go=$(it_ask "  Type YES to proceed: " "")
[ "$go" != "YES" ] && { it_warn "Cancelled. No changes made."; it_pause; exit 0; }

# Clear the immutable flag on contents where possible, then delete.
if command -v chattr >/dev/null 2>&1; then
    find "$resolved" -mindepth 1 -maxdepth 1 -exec chattr -R -i {} + 2>/dev/null
fi
# Delete all entries including dotfiles, without touching the folder itself.
it_run find "$resolved" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +

remaining=$(find "$resolved" -mindepth 1 2>/dev/null | wc -l)
if [ "$remaining" -eq 0 ]; then
    it_ok "SUCCESS: Folder '$resolved' has been cleared."
else
    it_warn "WARNING: $remaining item(s) could not be removed:"
    find "$resolved" -mindepth 1 2>/dev/null | head -10 | sed 's/^/    /'
fi

it_pause
