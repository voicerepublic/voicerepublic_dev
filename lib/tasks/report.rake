namespace :report do

  desc 'Report on files'
  task files: :environment do

    print 'collect data from storage'
    dir = Storage.directories.new(key: Settings.storage.media)
    sfiles = {}
    dir.files.each { |file| sfiles[file.key] = file }
    puts " #{sfiles.keys.size}"


    missing = []

    puts "scan talks for missings #{Talk.archived.count}"
    Talk.archived.each do |talk|
      uri, id = talk.uri, talk.id

      # define an expectation
      expected = [ "#{uri}/#{id}.journal",
                   "#{uri}/#{id}.mp3",
                   "#{uri}/#{id}.ogg",
                   "#{uri}/#{id}.m4a",
                   "#{uri}/#{id}-clean.mp3",
                   "#{uri}/#{id}-clean.ogg",
                   "#{uri}/#{id}-clean.m4a" ]
      #if files = rfiles[id]
      #  files.each do |file|
      #    expected << "#{uri}/#{file}"
      #  end
      #end
      
      (talk.storage || {}).keys.each do |key|
        sfiles.delete key
        expected.delete key
      end

      # accept additional files
      sfiles = sfiles.reject { |f| f =~ /^#{uri}\/override-#{id}\.ogg$/ }
      
      missing += expected
      print expected.empty? ? '.' : 'm'

      # # debug
      # unless expected.empty?
      #   puts "MISSING on Talk #{id} / #{uri}"
      #   puts *expected
      #   exit
      # end
    end

    puts
    puts
    puts 'MISSING'
    puts
    puts missing.sort
    puts
    puts 'UNREFERENCED FILES ON STORAGE'
    puts
    puts unreferenced = sfiles.keys
  end


  task upload: :environment do
    print 'collect data from archive_raw'
    base = File.expand_path(Settings.rtmp.archive_raw_path, Rails.root)
    files = Dir.glob(File.join(base, %w(* * * *.flv)))
    rfiles = files.inject({}) do |result, path|
      _, id = path.match(/\/t(\d+)-u\d+-\d+.flv$/).to_a
      raise path unless _
      result[id.to_i] ||= []
      result[id.to_i] << path
      result
    end
    puts " #{files.size}"

    dir = Storage.directories.new(key: Settings.storage.media)

    print 'collect data from storage'
    sfiles = []
    dir.files.each { |file| sfiles << file.key }
    puts " #{sfiles.size}"
    
    rfiles.each do |id, paths|
      talk = Talk.find_by(id: id)
      if talk.nil?
        puts "skip non existing talk with id #{id}"
        next
      end
      paths.each do |path|
        handle = File.open(path)
        key = talk.uri+'/'+File.basename(path)
        if sfiles.include?(key)
          puts "skip #{key}, already on s3"
        else
          puts "uploading #{path} to #{key}"
          dir.files.create key: key, body: handle
          talk.send(:cache_storage_metadata, path)
          talk.save!
        end
      end
    end
  end
  
  task update_metadata: :environment do
    todo = {}
    Talk.archived.order('id ASC').each do |talk|
      errors = []
      print "#{talk.id}: "
      dir = Storage.directories.get(Settings.storage.media, prefix: talk.uri+'/')
      dir.files.each do |file|
        unless talk.storage.has_key?(file.key)
          errors << file.key
          print "_"
          #talk.send(:cache_storage_metadata, ) and talk.save!
        else
          print case file.key
                when /flv$/ then 'f'
                when /mp3$/ then 'm'
                when /m4a$/ then 'a'
                when /ogg$/ then 'o'
                when /journal$/ then 'j'
                else '?'
                end
        end
      end
      unless errors.empty?
        puts
        puts *errors
        todo[talk.id] = errors
      else
        puts
      end
    end

    dir = Storage.directories.get(Settings.storage.media)
    todo.each do |id, paths|
      talk = Talk.find(id)
      paths.each do |path|
        puts "update info for #{path}"
        file = dir.files.get(path)
        name = File.basename(path)
        File.open(name, 'wb') { |f| f.write(file.body) }
        talk.send(:cache_storage_metadata, name)
        talk.save!
        File.unlink(name)
      end
    end
  end
  
  desc 'List files on storage'
  task storage: :environment do
    dir = Storage.directories.new(key: Settings.storage.media)
    dir.files.each { |file| puts file.key }
  end
  
end
