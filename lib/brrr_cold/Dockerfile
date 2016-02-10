FROM debian:jessie-backports

MAINTAINER Phil Hofmann "phil@200ok.ch"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq -y update && \
    apt-get -qq -y install icecast2 launchtool && \
    apt-get clean

CMD ["/start.sh"]
EXPOSE 8000
# VOLUME ["/var/log/icecast2", "/etc/icecast2"]
VOLUME ["/var/log/icecast2"]

ADD ./start.sh /start.sh
ADD ./icecast.xml-template.sh /icecast.xml-template.sh
# RUN chown -R icecast2 /etc/icecast2
