FROM jrottenberg/ffmpeg

<<<<<<< HEAD
RUN apt-get install wget -y && \
    wget -O /home/image.png https://www.seeklogo.net/wp-content/uploads/2016/06/Facebook-Live-logo.png
=======
MAINTAINER Josef Erben "josef@voicerepublic.com"

RUN apt-get update && apt-get install wget -y && \
    wget -O /home/image.png https://voicerepublic.com/images/vr-fb-live.png
>>>>>>> integration

CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]
ENV         LD_LIBRARY_PATH=/usr/local/lib
