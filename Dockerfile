FROM ubuntu:15.04

MAINTAINER Eliot Jordan <eliot.jordan@gmail.com>

ENV MAPNIK_VERSION="2.3"
ENV FITS_VERSION=0.8.5
ENV FITS_DOWNLOAD_URL="http://projects.iq.harvard.edu/files/fits/files/fits-${FITS_VERSION}.zip"

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:mapnik/nightly-2.3

RUN apt-get update && apt-get upgrade -y && \
    apt-get -y install \
        openjdk-8-jre-headless \
        openjdk-8-jdk \
        build-essential \
        nodejs \
        sqlite3 \
        libsqlite3-dev \
        gdal-bin \
        imagemagick --fix-missing \
        libmapnik \
        libmapnik-dev \
        mapnik-utils \
        mapnik-input-plugin-gdal \
        mapnik-input-plugin-ogr \
        build-essential \
        zip \
        unzip

# Install ruby
RUN apt-get -y install \
        git-core curl \
        libssl-dev \
        libreadline-dev \
        libyaml-dev \
        libxslt1-dev \
        libcurl4-openssl-dev \
        python-software-properties \
        libffi-dev \
        wget    

RUN wget http://ftp.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz && \
        tar -xzvf ruby-2.3.1.tar.gz && \
        cd ruby-2.3.1/ && \
        ./configure && \
        make && \
        make install

WORKDIR /usr/src/fits
RUN curl $FITS_DOWNLOAD_URL > fits.zip && \
        unzip fits.zip && \
        chmod a+x fits-$FITS_VERSION/*.sh && \
        cd fits-$FITS_VERSION/ && \
        mv *.properties *.sh lib tools xml /usr/local/bin

WORKDIR /usr/src

RUN gem install bundler -v 1.12.5
RUN gem install rails --no-doc  -v 5.0.0.1

RUN rails new geo_concerns -m https://raw.githubusercontent.com/projecthydra-labs/geo_concerns/master/template.rb

WORKDIR /usr/src/geo_concerns

# run download solr and fcrepo
RUN rake solr:clean
RUN ruby -e 'require "fcrepo_wrapper"; FcrepoWrapper.wrap( port: 8984 ) do |s|; end;'

ADD fedora.yml /usr/src/geo_concerns/config/fedora.yml
ADD solr.yml /usr/src/geo_concerns/config/solr.yml
ADD redis.yml /usr/src/geo_concerns/config/redis.yml

EXPOSE 3000

CMD rails s -b 0.0.0.0
