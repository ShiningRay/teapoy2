#!/bin/sh

docker run -it --rm -v `pwd`:/app -w /app shiningray/rvm:latest bash -l -c "bundle install --deployment --without development test"
docker build -t shiningray/teapoy2:latest .
