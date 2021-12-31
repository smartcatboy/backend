#! /bin/bash

# For test
#BACKEND_VERSION="0.15.4"
#AUTO_UPGRADE="yes"

UPDATE_URL=https://raw.githubusercontent.com/smartcatboy/deploy/main/VERSION
VERSION_INFO=`wget -qO - $UPDATE_URL | grep -w ^$BACKEND_VERSION`
if [ -z $VERSION_INFO ]; then
    echo "No need to upgrade."
    exit 0
fi

LATEST_VERSION=`echo $VERSION_INFO | awk '{print $2}'`
LATEST_ID=`echo $VERSION_INFO | awk '{print $3}'`
FORCE=`echo $VERSION_INFO | awk '{print $4}'`

if [[ $FORCE == "N" && $AUTO_UPGRADE != "yes" ]]; then
    echo "No need to upgrade."
    exit 0
fi

echo "Start upgrading to $LATEST_VERSION ($LATEST_ID) ..."
git fetch && git reset --hard $LATEST_ID
if [ $? -eq 0 ]; then
    echo "Upgrade successfully!"
    exit 0
else
    echo "Upgrade failed!"
    exit 1
fi

