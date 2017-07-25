FROM debian:jessie-backports

MAINTAINER Phil Hofmann "phil@voicerepublic.com"

ENV DEBIAN_FRONTEND noninteractive

# wav2json
RUN apt-get update && apt-get install -y wget make sudo g++
RUN wget https://github.com/beschulz/wav2json/archive/master.tar.gz
RUN tar xfvz master.tar.gz
RUN cd wav2json-master/build && make install_dependencies && make all

# aws cli
RUN apt-get -qq -y install curl python-pip && pip install awscli

# fidelity
RUN cd fidelity && ./install_dependencies.sh

# directories
ADD ./fidelity /fidelity

# files
ADD ./*.sh /
ADD ./*.rb /
ADD ./Gemfile /

CMD ["/run.sh"]
