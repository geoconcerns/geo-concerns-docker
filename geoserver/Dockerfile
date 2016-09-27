FROM tomcat:8.5-alpine

MAINTAINER Eliot Jordan <eliot.jordan@gmail.com>
# Adpated from thinkwhere/geoserver
# Credit: Tim Sutton<tim@linfiniti.com>
#         kartoza/docker-geoserver

RUN apk update
ENV GS_VERSION 2.9.1
ENV GEOSERVER_DATA_DIR /opt/geoserver/data_dir

RUN mkdir -p $GEOSERVER_DATA_DIR

# Unset Java related ENVs since they may change with Oracle JDK
ENV JAVA_VERSION=
ENV JAVA_DEBIAN_VERSION=

ADD resources /tmp/resources

# Optionally add JAI and ImageIO for improved performance.
WORKDIR /tmp
ARG JAI_IMAGEIO=true
RUN if [ "$JAI_IMAGEIO" = true ]; then \
    wget http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz && \
    wget http://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
    gunzip -c jai-1_1_3-lib-linux-amd64.tar.gz | tar xf - && \
    gunzip -c jai_imageio-1_1-lib-linux-amd64.tar.gz | tar xf - && \
    mv /tmp/jai-1_1_3/lib/*.jar $JAVA_HOME/lib/ext/ && \
    mv /tmp/jai-1_1_3/lib/*.so $JAVA_HOME/lib/amd64/ && \
    mv /tmp/jai_imageio-1_1/lib/*.jar $JAVA_HOME/lib/ext/ && \
    mv /tmp/jai_imageio-1_1/lib/*.so $JAVA_HOME/lib/amd64/ && \
    rm /tmp/jai-1_1_3-lib-linux-amd64.tar.gz && \
    rm -r /tmp/jai-1_1_3 && \
    rm /tmp/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
    rm -r /tmp/jai_imageio-1_1; \
    fi

WORKDIR $CATALINA_HOME
# Fetch the geoserver war file if it
# is not available locally in the resources dir and
RUN if [ ! -f /tmp/resources/geoserver.zip ]; then \
    wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/geoserver-${GS_VERSION}-war.zip \
      -O /tmp/resources/geoserver.zip; \
    fi; \
    mkdir /tmp/geoserver \
    && unzip /tmp/resources/geoserver.zip -d /tmp/geoserver \
    && mkdir $CATALINA_HOME/webapps/geoserver \
    && unzip /tmp/geoserver/geoserver.war -d $CATALINA_HOME/webapps/geoserver \
    && rm -rf $CATALINA_HOME/webapps/geoserver/data \
    && rm -rf /tmp/geoserver

# Install any plugin zip files in resources/plugins
RUN if ls /tmp/resources/plugins/*.zip > /dev/null 2>&1; then \
      for p in /tmp/resources/plugins/*.zip; do \
        unzip $p -d /tmp/gs_plugin \
        && mv /tmp/gs_plugin/*.jar $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/ \
        && rm -rf /tmp/gs_plugin; \
      done; \
    fi;

# Overlay files and directories in resources/overlays if they exist
RUN if ls /tmp/resources/overlays/* > /dev/null 2>&1; then \
      cp -rf /tmp/resources/overlays/* /; \
    fi;

# Optionally disable GeoWebCache
ARG DISABLE_GWC=false
RUN if [ "$DISABLE_GWC" = true ]; then \
      rm $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/*gwc*; \
    fi;	

# Optionally remove Tomcat manager, docs, and examples
ARG TOMCAT_EXTRAS=false
RUN if [ "$TOMCAT_EXTRAS" = false ]; then \
    rm -rf $CATALINA_HOME/webapps/ROOT && \
    rm -rf $CATALINA_HOME/webapps/docs && \
    rm -rf $CATALINA_HOME/webapps/examples && \
    rm -rf $CATALINA_HOME/webapps/host-manager && \
    rm -rf $CATALINA_HOME/webapps/manager; \
  fi;

# Delete resources after installation
RUN rm -rf /tmp/resources

#ENV GEOSERVER_HOME /opt/geoserver

#ENTRYPOINT "/opt/geoserver/bin/startup.sh"
#CMD "/opt/geoserver/bin/startup.sh"
EXPOSE 8080
