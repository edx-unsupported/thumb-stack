#!/bin/bash

THUMB=$(dirname "$0")

echo "Thumb drive is $THUMB"

if [ ! -f "$THUMB/birch-devstack.box" ]; then
    echo "There's no birch-devstack.box there"
    exit 1
fi

VAGRANT=$(which vagrant)

if [ -z "$VAGRANT" ]; then
    echo "You must install vagrant first"
    exit 1
fi

export OPENEDX_RELEASE=named-release/birch
vagrant box add "$THUMB/birch-devstack.box" --name=birch-devstack
mkdir devstack
cd devstack
cp "$THUMB/Vagrantfile" .
vagrant up --no-provision
git clone "$THUMB/edx-platform-bare" edx-platform
git -C edx-platform remote set-url origin https://github.com/edx/edx-platform.git
git clone "$THUMB/cs_comments_service-bare" cs_comments_service
git -C cs_comments_service remote set-url origin https://github.com/edx/cs_comments_service.git
vagrant provision
