FROM ruby:2.3.1-alpine

MAINTAINER Eliot Jordan <eliot.jordan@gmail.com>
# Adapted from centurylink/alpine-rails

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev sqlite-dev" \
    RUBY_PACKAGES="ruby ruby-io-console ruby-json yaml nodejs" \
    RAILS_VERSION="5.0.0.1"

RUN \
  apk --update --upgrade add $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES && \
  gem install -N bundler  && \
  rm -rf /var/cache/apk/*
  
RUN gem install -N nokogiri && \
  gem install -N rails --version "$RAILS_VERSION" && \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \

  # cleanup and settings
  bundle config --global build.nokogiri  "--use-system-libraries" && \
  bundle config --global build.nokogumbo "--use-system-libraries" && \
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/* && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem

WORKDIR /usr/src

RUN yes Y | rails new geoblacklight -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/master/template.rb
WORKDIR /usr/src/geoblacklight

# Add geoblacklight-messaging gem and set workers class
RUN echo "gem 'geoblacklight_messaging'" >> Gemfile && \
  bundle install && \
  rails generate geoblacklight_messaging:install

ENV WORKERS GeoblacklightMessaging::GeoblacklightEventHandler

# Add default env variable referencing our solr container
# Depends on --link my_solr_container:solr
ENV SOLR_URL http://solr:8983/solr/geoblacklight

VOLUME /usr/src/geoblacklight/tmp

EXPOSE 3000

CMD rails server -b 0.0.0.0 & rake sneakers:run
