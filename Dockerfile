FROM openjdk:8u191-jre-alpine3.8

LABEL author="Ian Robert O'Brien" \
      maintainer="Ian Robert O'Brien <ian.r.obrien@protonmail.com>"

USER root

ENV H2DIR=/opt/h2 \
    H2VERS=1.4.193 \
    H2DATA=/opt/h2-data \
    H2CONF=/opt/h2-conf

ADD start.sh /tmp/

RUN apk update && apk add curl unzip && \
    mkdir -p ${H2CONF} ${H2DATA}/data && \
    addgroup -S h2 && \
    adduser -S -D -g h2 -h ${H2DATA}/data h2 && \
    curl -L http://www.h2database.com/h2-2018-03-18.zip -o /tmp/h2.zip && \
    unzip -q /tmp/h2.zip -d /opt/ && \
    rm /tmp/h2.zip && mv /tmp/start.sh ${H2DIR}/bin && \
    chmod 755 ${H2DIR}/bin/start.sh ${H2DIR}/bin/h2.sh && \
    chown -R h2:h2 /opt/h2*

USER h2
WORKDIR ${H2DIR}
VOLUME ${H2DATA}
EXPOSE 8181 1521

CMD ["/opt/h2/bin/start.sh"]
