#!/bin/bash

mkdir -p /opt/persistent-evdev

cp config.json /opt/persistent-evdev/
cp persistent-evdev.py /opt/persistent-evdev/

cp persistent-evdev.service /etc/systemd/system/
cp 60-persistent-evdev-uinput.rules /etc/udev/rules.d/

systemctl daemon-reload