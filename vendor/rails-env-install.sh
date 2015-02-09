#!/bin/bash

sudo apt-add-repository ppa:ubuntu-on-rails/ppa
sudo apt-get update
sudo apt-get install -y gedit-gmate vim-gnome mercurial tortoisehg-nautilus
sudo apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion

echo '173.212.254.96 rubygems.org' | sudo tee -a /etc/hosts
echo '173.212.254.96 production.cf.rubygems.org' | sudo tee -a /etc/hosts
echo '173.212.254.96 production.s3.rubygems.org' | sudo tee -a /etc/hosts

bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)

. ~/.bashrc

rvm install 1.8.7
rvm use 1.8.7 --default

sudo apt-get install -y mysql-server libmysqlclient-dev imagemagick 

wget http://nodejs.org/dist/node-v0.4.12.tar.gz -O /tmp/node-v0.4.12.tar.gz
cd /tmp
tar zxvf node-v0.4.12.tar.gz
cd node-v0.4.12
./configure
make
sudo make install
