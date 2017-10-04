FROM jrottenberg/ffmpeg

MAINTAINER Josef Erben "josef@voicerepublic.com"

RUN apt-get update && apt-get install wget -y && \
    wget -O /home/image.png https://voicerepublic.com/images/vr-fb-live.png

CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]
ENV         LD_LIBRARY_PATH=/usr/local/lib
