namespace :recordings do
  STREAMS_PATH = '/home/rails/recordings'
  RECORDINGS_PATH = "#{Rails.root}/public/system/recordings"

  desc "Merge streams per venue"
  task :merge => :environment do
    # Build records grouped by venue id:
    #   { '1' => [[v1-e2-1377005700.flv], [v1-e2-1377005703.flv]] }
    #   where filename constists of venue ID at the beginning and UNIX timestamp at the end
    records = {}
    flvs = Dir.entries(STREAMS_PATH).select { |f| f[-4..-1] == '.flv' }
    flvs.each do |file|
      details = file.split('-')
      venue_id = details.first.gsub('v', '')
      datetime = DateTime.strptime(details.last.gsub('.flv', ''), '%s')
      name = file.gsub('.flv', '')
      records[venue_id] = [] if records[venue_id].blank?
      records[venue_id] << [name, datetime]
    end

    # Merge existing streams of not live venues
    Dir.mkdir(RECORDINGS_PATH) unless File.exists?(RECORDINGS_PATH)
    records.each do |venue_id, streams|
      venue = Venue.find(venue_id)
      next if venue.live?

      recording = "v#{venue_id}-#{Time.now.strftime('%s')}"

      if streams.size == 1
        name = streams.first[0]
        `cd #{STREAMS_PATH} && ffmpeg -i #{name}.flv -vn #{recording}.m4a`
        save_recording(venue, recording)
        File.delete("#{STREAMS_PATH}/#{name}.flv")
      else
        # Convert FLV streams to WAVs
        streams = streams.sort_by { |_, datetime| datetime }
        streams.each { |name, _| `cd #{STREAMS_PATH} && ffmpeg -i #{name}.flv -vn #{name}.wav` }

        # Merge all WAVs into one WAV
        start_at = streams.first[1]
        sox = "sox -m #{streams.first[0]}.wav"
        streams[1..-1].each do |name, datetime|
          delay = ((datetime - start_at) * 24 * 60 * 60).to_i
          sox << " \"|sox #{name}.wav -p pad #{delay}\""
        end
        sox << " #{recording}.wav"
        `cd #{STREAMS_PATH} && #{sox}`

        # Convert WAV result to M4A
        `cd #{STREAMS_PATH} && ffmpeg -i #{recording}.wav #{recording}.m4a`
        save_recording(venue, recording)

        # Remove WAVs and FLVs
        File.delete("#{STREAMS_PATH}/#{recording}.wav")
        streams.each do |name, _|
          File.delete("#{STREAMS_PATH}/#{name}.wav")
          File.delete("#{STREAMS_PATH}/#{name}.flv")
        end
      end      
    end
  end

  def save_recording(venue, name)
    FileUtils.mv("#{STREAMS_PATH}/#{name}.m4a", "#{RECORDINGS_PATH}/#{name}.m4a")
    venue.update_column(:recording, "#{name}.m4a")
  end
end
