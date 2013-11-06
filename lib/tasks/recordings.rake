namespace :recordings do
  STREAMS_PATH = '/home/rails/recordings'

  desc "Merge streams per event"
  task :merge => :environment do
    Dir.mkdir(Venue::RECORDINGS_PATH) unless File.exists?(Venue::RECORDINGS_PATH)
    remove_empty_flvs

    errors = []
    grouped_streams.each do |event_id, streams|
      begin
        event = Event.find_by_id(event_id)
        archive_flvs(streams) and next if event.blank?
        next if event.venue.live?

        merge(event, streams)
      rescue Exception => e
        errors << [event_id, e.message, e.backtrace]
      end
    end

    raise errors.to_s if errors.any?
  end

  # Build grouped records by event:
  #   { '2' => [[v1-e2-1377005700.flv, <DateTime>], [v1-e2-1377005703.flv, <DateTime>]] }
  #   where filename constists of event ID at the beginning and UNIX timestamp at the end
  def grouped_streams
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

    records
  end

  def merge(event, streams)
    recording = "#{event.id}-#{Time.now.strftime('%s')}"

    if streams.size == 1
      name = streams.first[0]
      `cd #{STREAMS_PATH} && ffmpeg -i #{name}.flv -vn #{recording}.m4a`
      save_recording(event, recording)
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

      # Remove WAVs
      File.delete("#{STREAMS_PATH}/#{recording}.wav")
      streams.each { |name, _| File.delete("#{STREAMS_PATH}/#{name}.wav") }
    end

    archive_flvs(streams)
  end

  def save_recording(event, name)
    FileUtils.mv("#{STREAMS_PATH}/#{name}.m4a", "#{Venue::RECORDINGS_PATH}/#{name}.m4a")
    event.update_column(:recording, "#{name}.m4a")
  end

  def remove_empty_flvs
    flvs = Dir.entries(STREAMS_PATH).select { |f| f[-4..-1] == '.flv' }
    flvs.each do |file|
      path = "#{STREAMS_PATH}/#{file}"
      File.delete(path) if File.size(path) == 0
    end
  end

  def archive_flvs(streams)
    streams.each do |name, _|
      FileUtils.mv("#{STREAMS_PATH}/#{name}.flv", "#{Venue::RECORDINGS_ARCHIVE_PATH}/#{name}.flv")
    end
  end
end
