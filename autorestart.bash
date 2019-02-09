#!/bin/bash

echo " "
echo "This script will create a service file for the odind daemon."
echo "This will allow odind to be managed by the Linux systemd service manager."

#Set up odin masternode systemd service file
echo "Setting up Odin masternode system service"
servicefile=/etc/systemd/system/odin.service
if [ -f $servicefile ];
then
    cp $servicefile $servicefile.bak
    rm $servicefile
fi
echo "[Unit]" >> $servicefile
echo "Description=Odin Blockchain Daemon" >> $servicefile
echo "After=network.target" >> $servicefile
echo " " >> $servicefile
echo "[Service]" >> $servicefile
echo "User=root" >> $servicefile
echo "Group=root" >> $servicefile
echo "Type=forking" >> $servicefile
echo "PIDFile=/root/.odin/odin.pid" >> $servicefile
echo "ExecStart=/usr/bin/odind -daemon -pid=/root/.odin/odin.pid -conf=/root/.odin/odin.conf -datadir=/root/.odin" >> $servicefile
echo "Restart=always" >> $servicefile
echo "RestartSec=5" >> $servicefile
echo "PrivateTmp=true" >> $servicefile
echo "TimeoutStopSec=60s" >> $servicefile
echo "TimeoutStartSec=5s" >> $servicefile
echo "StartLimitInterval=120s" >> $servicefile
echo "StartLimitBurst=15" >> $servicefile
echo " " >> $servicefile
echo "[Install]" >> $servicefile
echo "WantedBy=multi-user.target" >> $servicefile

# Enable masternode service so it starts at boot, and start masternode
odin_enable="systemctl enable odin"
echo "Enabling odin masternode systemd service..."
eval $odin_enable
echo "Done.  The odind process should now automatically restart whenever the system reboots."
