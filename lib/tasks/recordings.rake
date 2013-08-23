namespace :recordings do
  STREAMS_PATH = '/home/rails/recordings'
  RECORDINGS_PATH = "#{Rails.root}/public/system/recordings"

  desc "Merge streams per event"
  task :merge => :environment do
    # Build records grouped by event id:
    #   { '2' => [[v1-e2-1377005700.flv, <DateTime>], [v1-e2-1377005703.flv, <DateTime>]] }
    #   where filename constists of event ID at the beginning and UNIX timestamp at the end
    records = {}
    flvs = Dir.entries(STREAMS_PATH).select { |f| f[-4..-1] == '.flv' }
    flvs.each do |file|
      details = file.split('-')
      event_id = details[1].gsub('e', '')
      datetime = DateTime.strptime(details.last.gsub('.flv', ''), '%s')
      name = file.gsub('.flv', '')
      records[event_id] = [] if records[event_id].blank?
      records[event_id] << [name, datetime]
    end

    # Merge existing streams
    Dir.mkdir(RECORDINGS_PATH) unless File.exists?(RECORDINGS_PATH)
    records.each do |event_id, streams|
      event = Event.find(event_id)
      next if event.venue.live?
      recording = "#{event_id}-#{Time.now.strftime('%s')}"

      if streams.size == 1
        name = streams.first[0]
        `cd #{STREAMS_PATH} && ffmpeg -i #{name}.flv -vn #{recording}.m4a`
        save_recording(event, recording)
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
        save_recording(event, recording)

        # Remove WAVs and FLVs
        File.delete("#{STREAMS_PATH}/#{recording}.wav")
        streams.each do |name, _|
          File.delete("#{STREAMS_PATH}/#{name}.wav")
          File.delete("#{STREAMS_PATH}/#{name}.flv")
        end
      end      
    end
  end

  def save_recording(event, name)
    FileUtils.mv("#{STREAMS_PATH}/#{name}.m4a", "#{RECORDINGS_PATH}/#{name}.m4a")
    event.update_column(:recording, "#{name}.m4a")
  end
end
