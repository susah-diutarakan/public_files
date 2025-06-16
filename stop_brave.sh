#!/bin/bash

# Script to stop Brave Browser, noVNC, VNC, Xvfb, Openbox, and D-Bus processes

echo "Stopping Brave Browser + noVNC setup..."

# Stop tightvncserver
echo "Stopping tightvncserver..."
tightvncserver -kill :1 2>/dev/null
pkill -9 -f Xtightvnc 2>/dev/null

# Stop noVNC proxy
echo "Stopping noVNC proxy..."
pkill -9 -f novnc_proxy 2>/dev/null

# Stop Brave Browser
echo "Stopping brave-browser..."
pkill -9 -f brave-browser 2>/dev/null

# Stop Xvfb
echo "Stopping Xvfb..."
pkill -9 -f "Xvfb :1" 2>/dev/null

# Stop Openbox
echo "Stopping openbox..."
pkill -9 -f openbox 2>/dev/null

# Stop D-Bus processes
echo "Stopping D-Bus processes..."
pkill -9 -f dbus-run-session 2>/dev/null
pkill -9 -f dbus-daemon 2>/dev/null

# Clean up runtime files
echo "Cleaning up runtime files..."
rm -f /var/run/dbus/* 2>/dev/null
rm -f /run/user/0/* 2>/dev/null
rm -f /tmp/.X11-unix/X1		#customs folder

pkill -9 -f "python3 -m websockify" 2>/dev/null

echo "All processes stopped and runtime files cleaned."

# Verify no processes remain
echo "Verifying shutdown..."
if ps aux | grep -E "vnc|novnc|Xvfb|openbox|brave|dbus" | grep -v grep > /dev/null; then
    echo "Warning: Some processes may still be running. Check manually with 'ps aux | grep -E \"vnc|novnc|Xvfb|openbox|brave|dbus\"'."
else
    echo "Success: All targeted processes are stopped."
fi
