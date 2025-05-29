#!/bin/bash

echo "🔄 Reloading Hyprland config..."
hyprctl reload

echo "🔁 Restarting Waybar..."
pkill waybar
nohup waybar >/dev/null 2>&1 &

# Uncomment as needed and add your tools below

# echo "🔊 Restarting audio (pipewire + wireplumber)..."
# systemctl --user restart pipewire pipewire-pulse wireplumber

# echo "🔔Restarting notification daemon..."
# pkill dunst
# nohup dunst >/dev/null 2>&1 &

# echo "Restarting network applet..."
# pkill nm-applet
# nohup nm-applet >/dev/null 2>&1 &

echo "Environment reloaded."

