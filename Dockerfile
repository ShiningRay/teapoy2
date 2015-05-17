FROM shiningray/ruby:2.1
MAINTAINER ShiningRay <tsowly@hotmail.com>
EXPOSE 3000
CMD [ "bundle exec rails s -e production -b0" ]
