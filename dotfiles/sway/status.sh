#!/usr/bin/env bash

while true; do
    printf "%s - %s%%" "$(date +'%d/%m/%Y %H:%M:%S')" "$(cat /sys/class/power_supply/BAT0/capacity)"
    sleep 1
done
