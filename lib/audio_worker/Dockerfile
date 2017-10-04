FROM debian:jessie-backports

MAINTAINER Phil Hofmann "phil@voicerepublic.com"

ENV DEBIAN_FRONTEND noninteractive

# wav2json
RUN apt-get update && apt-get install -y wget make sudo g++ sox libsox-fmt-mp3
RUN wget https://github.com/beschulz/wav2json/archive/master.tar.gz
RUN tar xfvz master.tar.gz
RUN cd wav2json-master/build && make install_dependencies && make all

# aws cli
RUN apt-get -qq -y install curl python-pip && pip install awscli

# directories
ADD ./fidelity /fidelity

# fidelity (ffmpeg & vorbis-tools already come with fidelity)
RUN cd fidelity && ./install_dependencies.sh

# files
ADD ./*.sh /
ADD ./*.rb /
ADD ./Gemfile /

RUN bundle install

CMD ["/run.sh"]
