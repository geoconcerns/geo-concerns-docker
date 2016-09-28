FROM solr:6.2.1-alpine

MAINTAINER Eliot Jordan <eliot.jordan@gmail.com>

USER root
RUN apk add --update bash && rm -rf /var/cache/apk/*
ENV PATH /opt/solr/bin:${PATH}
ENV GC_VERSION 0.0.10
ENV SOLR_HOME /var/solr/data/
ENV SOLR_CORE ${SOLR_HOME}hydra-development/

RUN apk --update --upgrade add curl && rm -rf /var/cache/apk/*

RUN mkdir -p ${SOLR_CORE}

ADD solr.xml ${SOLR_HOME}
ADD core.properties ${SOLR_CORE}

RUN curl -L https://github.com/projecthydra-labs/geo_concerns/archive/v${GC_VERSION}.tar.gz | \
    tar xz -C /tmp && \
    mv /tmp/geo_concerns-${GC_VERSION}/solr/config ${SOLR_CORE} && \
    mv ${SOLR_CORE}/config ${SOLR_CORE}/conf && \
    rm -rf /tmp/geo_concerns-${GC_VERSION}

# Add start-up script
ADD ./start.sh /opt/solr/start.sh

VOLUME ["/var/solr"]

CMD ["sh", "-c", "/opt/solr/start.sh"]
