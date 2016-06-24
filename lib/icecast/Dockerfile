FROM debian:jessie-backports

MAINTAINER Phil Hofmann "phil@voicerepublic.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq -y update && \
    apt-get -qq -y install curl && \
    apt-get -qq -y -t jessie-backports install icecast2 && \
    apt-get clean

RUN mkdir /share && \
    chown -R icecast2:icecast /share

EXPOSE 8000

VOLUME /share

ADD ./*.sh /

ADD redirect.html /usr/share/icecast2/web/

RUN chown -R icecast2 /etc/icecast2

USER icecast2

CMD ["/start.sh"]
