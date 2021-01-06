# Example Source JSON by Icecast
#
# {"audio_bitrate"=>239920,
# "audio_channels"=>1,
# "audio_samplerate"=>44100,
# "bitrate"=>0,
# "genre"=>"various",
# "ice-bitrate"=>239,
# "listener_peak"=>1,
# "listeners"=>0,
# "listenurl"=>"http://localhost:8000/d6ec5914-6340-4181-a059-4c395a292a87",
# "server_description"=>"Unspecified description",
# "server_name"=>"Unspecified name",
# "server_type"=>"application/ogg",
# "stream_start"=>"Mon, 30 May 2016 15:12:55 +0000",
# "stream_start_iso8601"=>"2016-05-30T15:12:55+0000",
# "subtype"=>"Vorbis",
# "dummy"=>nil}
#
class StreamStat < ApplicationRecord
  belongs_to :venue

  def values
    [
      venue_id,
      bitrate,
      listener_count,
      listener_peak,
      created_at
    ]
  end

end
