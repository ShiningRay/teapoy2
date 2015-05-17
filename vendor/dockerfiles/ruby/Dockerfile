FROM ubuntu
MAINTAINER ShiningRay <tsowly@hotmail.com>

RUN sed -i -e "s/archive.ubuntu.com/cn.archive.ubuntu.com/g" /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6 \
 && echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ruby2.1 libreadline6 libncurses5 libffi6 libmysqlclient18 libpq5 zlib1g libyaml-0-2 libssl1.0.0 \
 libxml2 libxslt1.1 libcurl3 libicu52 ca-certificates \
 && rm -rf /var/lib/apt/lists/*
RUN ln -sf /usr/lib/x86_64-linux-gnu/libruby-2.1.so.2.1 /usr/lib/x86_64-linux-gnu/libruby.so.2.1
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc" \
 && gem sources --remove https://rubygems.org/ \
 && gem sources -a https://ruby.taobao.org/ \
 && gem install bundler --no-rdoc --no-ri

CMD [ "irb" ]
