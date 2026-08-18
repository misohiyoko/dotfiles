#!/bin/bash
# Xwaylandが起動するまで待機
while ! xset q &>/dev/null; do
    sleep 0.5
done
setxkbmap -model jp106 -layout jp