FROM ubuntu
MAINTAINER ShiningRay <tsowly@hotmail.com>
 
# turn on universe packages
RUN sed -i -e "s/archive.ubuntu.com/ubuntu.mirrors.ucloud.cn/g" /etc/apt/sources.list \
 && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
 && apt-get update \
 && apt-get install -y curl --no-install-recommends && rm -rf /var/lib/apt/lists/*
# basics
# install RVM, Ruby, and Bundler
RUN \curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements && rvm install 2.1.5 && gem install bundler --no-ri --no-rdoc"
