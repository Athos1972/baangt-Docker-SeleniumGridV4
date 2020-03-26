#!/bin/bash

echo "starting VNC server ..."
export USER=root
alias python=python3
java -jar baangt/browserDrivers/selenium-server-4.0.0-alpha-5.jar standalone &
vncserver :1 -geometry 1280x800 -depth 24 && tail -F /root/.vnc/*.log
