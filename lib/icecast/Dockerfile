FROM debian:jessie-backports

MAINTAINER Phil Hofmann "phil@voicerepublic.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq -y update && \
    apt-get -qq -y install icecast2 curl && \
    apt-get clean

RUN mkdir /share && \
    chown -R icecast2:icecast /share

EXPOSE 8000

VOLUME /share

ADD ./*.sh /

RUN chown -R icecast2 /etc/icecast2

USER icecast2

CMD ["/start.sh"]
