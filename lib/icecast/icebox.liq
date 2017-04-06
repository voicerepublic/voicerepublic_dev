#!/usr/bin/liquidsoap

set("log.file.path", "/share/liquidsoap.log")

interlude1 = nrj(mean(single('./loop2.wav')))
interlude2 = nrj(mean(single('./loop3.wav')))

passwd = getenv("ICECAST_SOURCE_PASSWORD")

url = "http://localhost:8080/live"

stream0 = input.http(url)
stream1 = fallback(track_sensitive=false, [stream0, interlude1])
stream2 = strip_blank(stream1, max_blank=10.)
stream3 = fallback(track_sensitive=false, [stream2, interlude2])

streamer = output.icecast(host = "localhost",
                          port = 8080,
                          password = passwd)

streamer(%mp3(mono=true),
         mount = "/live.mp3",
         stream3)

streamer(%vorbis(channels=1),
         mount = "/live.ogg",
         stream3)

# TODO use `%fdkaac(channels=1)`
streamer(%aac(channels=1),
         mount = "/live.aac",
         stream3)
