# MIME::Types would return the wrong mime type for mp4. Making sure all our
# content-types are reported correctly.
class MIME::Types
  def type_for(filename, platform = false)
    file_suffix = filename.split(".").last.downcase
    super unless ['m4a', 'mp3', 'ogg', 'flv'].include? file_suffix

    mime_type = case file_suffix
    when "m4a" then "audio/mp4"
    when "mp3" then "audio/mpeg"
    when "ogg" then "audio/ogg"
    when "flv" then "video/x-flv"
    end

    [ MIME::Type.new(mime_type)]
  end
end
