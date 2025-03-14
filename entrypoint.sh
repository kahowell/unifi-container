#!/bin/bash

SYSTEM_PROPERTIES=/usr/lib/unifi/data/system.properties

set_value() {
    # Set values in /usr/lib/unifi/data/system.properties
    property=$1
    value=$2
    if grep -q "^${property}="; then
        sed -i "s#^${property}#${property}=${value}#" ${SYSTEM_PROPERTIES}
    else
        echo "${property}=${value}" >> ${SYSTEM_PROPERTIES}
    fi
}

if [ ! -f ${SYSTEM_PROPERTIES} ]; then
    touch ${SYSTEM_PROPERTIES}
fi

set_value db.mongo.local false
set_value db.mongo.uri mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_HOST}:${MONGO_PORT}/${MONGO_DBNAME}
set_value statdb.mongo.uri mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_HOST}:${MONGO_PORT}/${MONGO_DBNAME}_stat
set_value unifi.db.name ${MONGO_DBNAME}

# Adapted from /usr/lib/systemd/system/unifi.service from built container
/usr/bin/java \
    -Dfile.encoding=UTF-8 \
    -Djava.awt.headless=true \
    -Dapple.awt.UIElement=true \
    -Dunifi.core.enabled=${UNIFI_CORE_ENABLED} \
    -Dunifi.mongodb.service.enabled=${UNIFI_MONGODB_SERVICE_ENABLED} \
    $UNIFI_JVM_OPTS \
    -XX:+ExitOnOutOfMemoryError \
    -XX:+CrashOnOutOfMemoryError \
    -XX:ErrorFile=/usr/lib/unifi/logs/unifi_crash.log \
    -Xlog:gc:logs/gc.log:time:filecount=2,filesize=5M \
    --add-opens java.base/java.lang=ALL-UNNAMED \
    --add-opens java.base/java.time=ALL-UNNAMED \
    --add-opens java.base/sun.security.util=ALL-UNNAMED \
    --add-opens java.base/java.io=ALL-UNNAMED \
    --add-opens java.rmi/sun.rmi.transport=ALL-UNNAMED \
    -jar /usr/lib/unifi/lib/ace.jar start
