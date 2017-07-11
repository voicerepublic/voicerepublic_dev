#!/usr/bin/liquidsoap -v

set("log.file.path", "./liquidsoap.log")
set("log.stdout", true)

icecast_host = argv(1)
auido_file = argv(2)

icecast_port = 80
icecast_mount = "/live"
icecast_password = "12345"

source = single(audio_file)

ignore(output.icecast(
    %vorbis(channels=1),
    host=icecast_host,
    port=icecast_port,
    mount=icecast_mount,
    password=icecast_password,
    public=false,
    mean(source)
))
