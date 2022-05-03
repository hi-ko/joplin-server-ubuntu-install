#!/bin/bash

USER_ID=`id -u`

if [[ "$USER_ID" != "0" ]]
then
  echo "$0: You must run this script as root: $USER_ID"
  exit 1
fi

if [[ -f /etc/default/joplinrc ]];then
    . /etc/default/joplinrc
else
    echo ""
fi

JOPLIN_HOME="${JOPLIN_HOME:-/opt/joplin}"

apt update
apt -y install vim git

## install nodejs 16
# from https://github.com/nodesource/distributions
# remove old version 
apt-get -y purge nodejs npm
# add repo
apt-get -y install curl dirmngr apt-transport-https lsb-release ca-certificates
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -

apt-get install -y nodejs
# in case we need to compile modules
apt -y install build-essential python

# install the Yarn package manager
#curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
#echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# apt-get update && apt-get install yarn

# yarn is self contained in nodejs 16 but needs to be enabled:
corepack enable

JOPLIN_USER=joplin
id -u $JOPLIN_USER &>/dev/null || sudo useradd --create-home --shell /bin/bash $JOPLIN_USER

mkdir -p $JOPLIN_HOME
chown $JOPLIN_USER: $JOPLIN_HOME
