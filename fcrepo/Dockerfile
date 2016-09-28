FROM ruby:2.3.1-alpine

RUN apk add --update bash openjdk8 && rm -rf /var/cache/apk/*

RUN mkdir fedora && mkdir fedora/tmp
WORKDIR /opt/fedora

ADD Gemfile /opt/fedora
ADD .fcrepo_wrapper /opt/fedora
RUN gem install bundler && bundle install

# dowload fcrepo
RUN ruby -e "require 'fcrepo_wrapper'; FcrepoWrapper.wrap { }"

EXPOSE 8984

CMD fcrepo_wrapper
