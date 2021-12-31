#! /bin/bash

# For test
#BACKEND_VERSION="0.15.4"
AUTO_UPGRADE="yes"

LOCAL=`pwd`
UPDATE_URL=https://raw.githubusercontent.com/smartcatboy/deploy/main/VERSION
VERSION_INFO=`wget -qO - $UPDATE_URL | grep -v ^\# | grep -w ^$BACKEND_VERSION`
LATEST_VERSION=`echo $VERSION_INFO | awk '{print $2}'`
if [[ -z $LATEST_VERSION ]]; then
    echo "No need to upgrade."
    exit 0
fi
LATEST_ID=`echo $VERSION_INFO | awk '{print $3}'`
if [[ $LATEST_ID == "#" ]]; then
    rm -rf /tmp/compose
    LATEST_ID=`git clone -q https://github.com/smartcatboy/compose.git /tmp/compose && \
    cd /tmp/compose && git checkout -q tags/$LATEST_VERSION && \
    git ls-files -s backend | grep -w backend$ | awk '{print $2}'`
fi
FORCE=`echo $VERSION_INFO | awk '{print $4}'`
if [[ $FORCE == "N" && $AUTO_UPGRADE != "yes" ]]; then
    echo "No need to upgrade."
    exit 0
fi

echo "Start upgrading to $LATEST_VERSION ($LATEST_ID) ..."
cd $LOCAL && git fetch && git reset --hard $LATEST_ID
if [ $? -eq 0 ]; then
    echo "Upgrade successfully!"
    exit 0
else
    echo "Upgrade failed!"
    exit 1
fi
