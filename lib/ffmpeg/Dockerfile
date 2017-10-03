FROM jrottenberg/ffmpeg

RUN apt-get install wget -y && \
    wget -O /home/image.png https://www.seeklogo.net/wp-content/uploads/2016/06/Facebook-Live-logo.png

CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]
ENV         LD_LIBRARY_PATH=/usr/local/lib
