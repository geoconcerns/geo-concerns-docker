FROM solr:5.3.2-alpine

MAINTAINER Eliot Jordan <eliot.jordan@gmail.com>

USER root

ENV PATH /opt/solr/bin:${PATH}
ENV GBL_VERSION 1.2.0
ENV SOLR_HOME /var/solr/data/
ENV GEO_CORE ${SOLR_HOME}geoblacklight/

RUN apk --update --upgrade add curl && rm -rf /var/cache/apk/*

RUN mkdir -p ${GEO_CORE}

ADD solr.xml ${SOLR_HOME}
ADD core.properties ${GEO_CORE}

RUN curl -L https://github.com/geoblacklight/geoblacklight/archive/v${GBL_VERSION}.tar.gz | \
    tar xz -C /tmp && \
    mv /tmp/geoblacklight-${GBL_VERSION}/solr/conf ${GEO_CORE} && \
    rm -rf /tmp/geoblacklight-${GBL_VERSION}

# Add start-up script
ADD ./start.sh /opt/solr-5.3.2/start.sh

VOLUME ["/var/solr"]

CMD ["sh", "-c", "/opt/solr-5.3.2/start.sh"]
