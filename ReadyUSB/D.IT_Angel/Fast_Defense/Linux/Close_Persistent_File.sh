#!/usr/bin/env bash
# ScriptID: ST-LIN-0659  |  659.Close_Persistent_File.sh
# Force-deletes a file that is held open by a running process.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "659.Close_Persistent_File.sh" "ST-LIN-0659" "Force-deletes a file locked/held open by another running process"
it_need_root "$@"

f=$(it_ask "Paste the FULL file path to delete, then press Enter: " "")
if [ -z "$f" ]; then it_err "No path provided."; it_pause; exit 1; fi
if [ ! -e "$f" ]; then it_err "File not found: '$f'"; it_pause; exit 1; fi
if [ -d "$f" ]; then it_err "'$f' is a directory. Use 660.Empty_content_any_folder.sh instead."; it_pause; exit 1; fi

# 1) Try a straight delete.
if it_run rm -f -- "$f" 2>/dev/null && [ ! -e "$f" ]; then
    it_ok "Deleted."; it_pause; exit 0
fi

# 2) Identify and kill the processes holding it open.
it_info "File is busy - finding the processes holding it open..."
holders=""
if command -v fuser >/dev/null 2>&1; then
    holders=$(fuser "$f" 2>/dev/null | tr -s ' ')
elif command -v lsof >/dev/null 2>&1; then
    holders=$(lsof -t -- "$f" 2>/dev/null | tr '\n' ' ')
fi

if [ -n "$holders" ]; then
    it_warn "Holding PIDs:$holders"
    if command -v fuser >/dev/null 2>&1; then
        it_run fuser -k "$f" 2>/dev/null
    else
        for p in $holders; do it_run kill -TERM "$p" 2>/dev/null; done
    fi
    sleep 1
    for p in $holders; do kill -0 "$p" 2>/dev/null && it_run kill -KILL "$p" 2>/dev/null; done
else
    it_note "No process appears to hold the file (may be a permission/immutable issue)."
fi

# 3) Clear an immutable attribute if set, then delete again.
if command -v chattr >/dev/null 2>&1; then it_run chattr -i -- "$f" 2>/dev/null; fi

if it_run rm -f -- "$f" 2>/dev/null && [ ! -e "$f" ]; then
    it_ok "Deleted after clearing the lock."
else
    it_err "Could not delete '$f'. It may be on a read-only mount or held by the kernel."
fi

it_pause
