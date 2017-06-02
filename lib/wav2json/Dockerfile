# docker run -it branch14/wav2json /bin/bash

FROM debian:jessie-backports

MAINTAINER Phil Hofmann "phil@voicerepublic.com"

ENV DEBIAN_FRONTEND noninteractive

## add our user and group first to make sure their IDs get assigned
## consistently, regardless of whatever dependencies get added
#RUN groupadd -r icecast && \
#  useradd -r -g icecast icecast2

# RUN apt-get update && apt-get install -y git
# RUN git clone https://github.com/beschulz/wav2json.git
# RUN cd wav2json/build

RUN apt-get update && apt-get install -y wget make sudo g++
RUN wget https://github.com/beschulz/wav2json/archive/master.tar.gz
RUN tar xfvz master.tar.gz
RUN cd wav2json-master/build && make install_dependencies && make all

ADD ./*.sh /

RUN mkdir /share
VOLUME /share

# USER icecast2

CMD ["/run.sh"]
