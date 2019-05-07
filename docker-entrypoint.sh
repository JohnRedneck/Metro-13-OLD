#!/bin/sh

mkdir /byond
chown $RUNAS:$RUNAS /byond /bs12 metro13.rsc

gosu $RUNAS DreamDaemon metro13.dmb 8000 -trusted -verbose
