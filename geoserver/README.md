### Build

```
docker build --build-arg TOMCAT_EXTRAS=false -t geoconcerns/geoserver .
```

### Run

```
docker run \
    --name=geoserver \
    -p 8181:8080 \
    -d \
    -t geoconcerns/geoserver
```

### More

[https://github.com/thinkWhere/GeoServer-Docker](https://github.com/thinkWhere/GeoServer-Docker)