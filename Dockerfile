FROM shiningray/ruby:2.1
MAINTAINER ShiningRay <tsowly@hotmail.com>
EXPOSE 3000
RUN apt-get update \
  && apt-get install -y libmysqlclient18 imagemagick zlib1g libyaml-0-2 libssl1.0.0 libreadline6 libncurses5 libffi6 nodejs\
  && rm -rf /var/lib/apt/* 
RUN ln -sf /usr/lib/x86_64-linux-gnu/libruby-2.1.so.2.1 /usr/lib/x86_64-linux-gnu/libruby.so.2.1
RUN mkdir -p /app
COPY . /app
ADD config/database.default.yml /app/config/
