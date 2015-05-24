#!/bin/sh

cd /tmp
if [ ! -d teapoy2 ]; then
  git clone git@bitbucket.org:shiningray/teapoy2.git
  cd teapoy2
else
  cd teapoy2
  git reset --hard
  git pull master
fi

docker run -v `pwd`:/teapoy2 -w /teapoy2 shiningray/rvm:latest bundle install --deployment --without development test

docker built -t shiningray/teapoy2:latest vendor/dockerfiles/ruby/Dockerfile
