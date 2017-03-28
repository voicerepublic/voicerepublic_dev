#!/bin/sh

# Takes a format & a password.

format=$1
password=$2

transcode='ffmpeg -re -i http://localhost:8080/live -vn'

running=true

stop () {
    echo -n 'Stopping...'
    running=false
    kill $pid
}

trap stop 2

while [ $running = true ]; do

    echo "Start transcoding to $format..."
    
    case $format in
        mp3)
            $transcode \
                -codec:a libmp3lame -b:a 64k -f mp3 \
                -content_type audio/mpeg \
                icecast://source:$password@localhost:8080/live.mp3 \
                2>&1 >> /share/transcode_mp3.log &
            ;;
        ogg)
            $transcode \
                -codec:a libvorbis -qscale:a 5 -f ogg \
                -content_type audio/ogg \
                icecast://source:$password@localhost:8080/live.ogg \
                2>&1 >> /share/transcode_ogg.log &
            ;;
        oga)
            $transcode \
                -codec:a libvorbis -qscale:a 5 -f oga \
                -content_type audio/ogg \
                icecast://source:$password@localhost:8080/live.oga \
                2>&1 >> /share/transcode_oga.log &
            ;;
        aac)
            $transcode \
                -b:a 128k -f adts \
                -content_type audio/aac \
                icecast://source:$password@localhost:8080/live.aac \
                2>&1 >> /share/transcode_aac.log &
            ;;
        m4a)
            $transcode \
                -b:a 128k -f adts \
                -content_type audio/m4a \
                icecast://source:$password@localhost:8080/live.m4a \
                2>&1 >> /share/transcode_m4a.log &
            ;;
    esac

    pid=$!
    echo "Started with pid $pid."
    wait $pid
    echo "Process $pid came to an end."
    
    sleep 1
    
done

echo 'stopped for good.'

exit
