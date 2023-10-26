#!/bin/bash
#install tools
sudo apt update
sudo apt install -y gnupg curl git openjdk-11-jdk zip unzip
#install posgresql
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt install -y postgresql-14
#install redis
sudo apt install -y redis
#install tomcat
sudo apt install -y tomcat9 
#install mongodb
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update
sudo apt-get install -y mongodb-org
#install gradle
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install gradle 7.3.3
#start tools on boot
sudo systemctl enable postgresql
sudo systemctl enable redis-server
sudo systemctl enable tomcat8
sudo systemctl enable mongod


