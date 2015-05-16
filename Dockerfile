FROM rails:onbuild
MAINTAINER ShiningRay <tsowly@hotmail.com>
RUN apt-get install -y --no-install-recommends \
  imagemagick git \
	&& rm -rf /var/lib/apt/lists/*
