#!/usr/bin/liquidsoap

set("log.file.path", "/share/liquidsoap.log")

interlude1 = nrj(mean(single('./loop2.wav')))
interlude2 = nrj(mean(single('./loop3.wav')))

passwd = getenv("ICECAST_SOURCE_PASSWORD")

url = "http://localhost:8080/live"

client_token = getenv("CLIENT_TOKEN")
callback_url = getenv("CALLBACK_URL") ^ "/" ^ client_token

# ------------------------------ CALLBACKS

def input_connect(headers)
  payload = [("headers",headers)]
  ignore(http.post(callback_url ^ '/input_connect',
                   data=json_of(compact=true, payload)))
end

def input_disconnect()
  ignore(http.post(callback_url ^ '/input_disconnect'))
end

def output_connect()
  ignore(http.post(callback_url ^ '/output_connect'))
end

def output_disconnect()
  ignore(http.post(callback_url ^ '/output_disconnect'))
end

def output_error(message)
  payload = [("message",message)]
  ignore(http.post(callback_url ^ '/output_error',
                   data=json_of(compact=true, payload)))
  1. # retry in secs
end

def output_start()
  ignore(http.post(callback_url ^ '/output_start'))
end

def output_stop()
  ignore(http.post(callback_url ^ '/output_stop'))
end

# ------------------------------ INPUTS

stream0 = input.http(url,
                     poll_delay=1.0,
                     # requires v1.2
                     # on_connect=input_connect,
                     # on_disconnect=input_disconnect
                     )

stream1 = fallback(track_sensitive=false, [stream0, mean(stream0), interlude1])

stream2 = strip_blank(stream1, max_blank=10.)
#stream2 = strip_blank(stream1, max_blank=10., threshold=-50.)

stream3 = fallback(track_sensitive=false, [stream2, interlude2])

final = stream3

# ------------------------------ OUTPUTS

streamer = output.icecast(# for version < 1.1.1
                          # restart=true,
                          on_connect=output_connect,
                          on_disconnect=output_disconnect,
                          on_error=output_error,
                          on_start=output_start,
                          on_stop=output_stop,
                          protocol='http', # default
                          host="localhost", # default
                          port=8080,
                          password=passwd)

streamer(mount="/live.mp3", %mp3(mono=true), final)

streamer(mount="/live.ogg", %vorbis(channels=1), final)

# TODO use `%fdkaac(channels=1)`
streamer(mount="/live.aac", %aac(channels=1), final)
