FROM docker.io/library/ubuntu:noble-20250127
ARG unifi_version=9.0.114-28033-1
ENV UNIFI_CORE_ENABLED=false
ENV UNIFI_MONGODB_SERVICE_ENABLED=false
ENV UNIFI_JVM_OPTS="-Xmx1024M -XX:+UseParallelGC"
ENV MONGO_HOST=localhost
ENV MONGO_PORT=27017
ENV MONGO_USER=ubnt
ENV MONGO_PASS=ubnt
ENV MONGO_DBNAME=ubnt
# Adapted from https://help.ui.com/hc/en-us/articles/220066768-Updating-and-Installing-Self-Hosted-UniFi-Network-Servers-Linux
ADD --chmod=644 https://dl.ui.com/unifi/unifi-repo.gpg /etc/apt/trusted.gpg.d/unifi-repo.gpg
RUN apt-get update && apt-get install -y ca-certificates apt-transport-https
RUN echo 'deb [ arch=amd64,arm64 ] https://www.ui.com/downloads/unifi/debian stable ubiquiti' > /etc/apt/sources.list.d/100-ubnt-unifi.list
#RUN apt-get update && apt-get install -y unifi=${unifi_version} mongodb-server- mongodb-10gen- mongodb-org-server-
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  adduser \
  curl \
  binutils \
  logrotate \
  openjdk-21-jre-headless
RUN apt-get update && \
  apt-get download unifi=${unifi_version} && \
  dpkg -i --ignore-depends=mongodb-org-server unifi_${unifi_version}_all.deb && \
  rm -rf unifi_${unifi_version}_all.deb
WORKDIR /usr/lib/unifi
ADD entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh
EXPOSE 53 8080 8443 8880 8843 6789
EXPOSE 53/udp 3478/udp 5514/udp 10001/udp 1900/udp 123/udp
