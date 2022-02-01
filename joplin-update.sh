#based on https://github.com/hi-ko/joplin-server-ubuntu-install

#Deleted node_modules and package-lock.json

cd /home/joplin

wget -O joplin-build.sh https://raw.githubusercontent.com/hi-ko/joplin-server-ubuntu-install/master/joplin-build.sh
wget -O joplin.service https://raw.githubusercontent.com/hi-ko/joplin-server-ubuntu-install/master/joplin.service
wget -O run.sh https://raw.githubusercontent.com/hi-ko/joplin-server-ubuntu-install/master/run.sh


if [[ \ $*\  == *\ --full\ * ]] || [[ \ $*\  == *\ -f\ * ]]; then
wget -O joplin-requirements.sh https://raw.githubusercontent.com/hi-ko/joplin-server-ubuntu-install/master/joplin-requirements.sh
sudo bash /home/joplin/joplin-requirements.sh
fi

cd /home/joplin/joplin

git fetch --tags
latest=(`git describe --tags --match "server-*" --abbrev=0 $(git rev-list --tags --max-count=1)`)

read -p "Continue to update $latest? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

git checkout $latest

#then stop your joplin server and build latest version
sudo systemctl stop joplin-server

cd /home/joplin
bash /home/joplin/joplin-build.sh
sudo systemctl start joplin-server
sudo service nginx restart