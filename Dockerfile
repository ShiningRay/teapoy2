FROM shiningray/ruby:2.1
MAINTAINER ShiningRay <tsowly@hotmail.com>
EXPOSE 3000
RUN apt-get update \
  && apt-get install -y libmysqlclient18 imagemagick zlib1g libyaml-0-2 libssl1.0.0 libreadline6 libncurses5 libffi6 nodejs\
  && rm -rf /var/lib/apt/*
COPY . /teapoy2
WORKDIR /teapoy2
VOLUME ["/teapoy2"]
ADD config/database.default.yml /teapoy2/config/database.yml
CMD ["bundle", "exec", "rails", "-b0", "-e production"]
