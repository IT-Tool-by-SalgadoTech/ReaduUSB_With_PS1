#!/usr/bin/env bash
# ScriptID: ST-LIN-0655  |  655.Close_RDP_Fix1.sh
# Disables Remote Desktop by stopping and disabling the RDP servers (xrdp / gnome-remote-desktop).
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if   [ -f "$DIR/_itlib.sh" ];    then . "$DIR/_itlib.sh"
elif [ -f "$DIR/../_itlib.sh" ]; then . "$DIR/../_itlib.sh"
else echo "_itlib.sh not found"; exit 1; fi

it_banner "655.Close_RDP_Fix1.sh" "ST-LIN-0655" "Disables Remote Desktop (RDP) by stopping and disabling the xrdp/GNOME RDP services"
it_need_root "$@"

found=0
for svc in xrdp xrdp-sesman gnome-remote-desktop; do
    if it_service_exists "$svc"; then
        found=1
        it_service_stop "$svc"
        it_service_disable "$svc"
        it_ok "Service '$svc' stopped and disabled."
    fi
done

if [ "$found" -eq 0 ]; then
    if ! it_have_systemd; then
        it_warn "systemd is not active here; cannot query RDP services."
    else
        it_ok "No RDP server (xrdp / gnome-remote-desktop) is installed. RDP is already off."
    fi
fi

# Report whether anything is still listening on 3389.
if ss -H -lnt 2>/dev/null | grep -q ':3389'; then
    it_warn "Something is STILL listening on TCP 3389 - use 656.Close_RDP_Fix2.sh to block the port."
else
    it_ok "Nothing is listening on TCP 3389."
fi

it_pause
