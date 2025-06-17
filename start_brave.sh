#!/bin/bash
[ -f "/tmp/.X1-lock" ] && rm "/tmp/.X1-lock"
USER=root tightvncserver :1 -geometry 1900x900 -depth 24 &
sleep 3
#/opt/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 &
/opt/novnc/utils/novnc_proxy --file-only --vnc localhost:5901 --listen 6080 --cert /opt/novnc/novnc.crt --key /opt/novnc/novnc.key & #SSL
