#!/bin/bash
apt update
apt -y install vim git

## install nodejs 16
remove old version 
apt purge nodejs npm
# add repo
apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -

apt -y install nodejs
# # in case we need to compile modules
apt -y install build-essential python

JOPLIN_USER=joplin
id -u $JOPLIN_USER &>/dev/null || sudo useradd --create-home --shell /bin/bash $JOPLIN_USER


# as user joplin create dirs and checkout specific version
sudo su - $JOPLIN_USER <<'EOF'
mkdir -p logs
if [ ! -d joplin ];then
    git clone https://github.com/laurent22/joplin.git
fi
cd joplin
git fetch --tags
git checkout server-v2.6.14
exit
EOF
