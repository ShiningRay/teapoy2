FROM shiningray/ruby:2.1
MAINTAINER ShiningRay <tsowly@hotmail.com>
EXPOSE 3000
RUN apt-get update \
  && apt-get install -y libmysqlclient18 imagemagick zlib1g libyaml-0-2 libssl1.0.0 libreadline6 libncurses5 libffi6 nodejs\
  && rm -rf /var/lib/apt/* 
COPY . /app
WORKDIR /app
VOLUME ["/app"]
ADD config/database.default.yml /app/config/
