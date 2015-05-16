FROM rails:4.2
RUN apt-get install -y --no-install-recommends \
  imagemagick \
	&& rm -rf /var/lib/apt/lists/*
