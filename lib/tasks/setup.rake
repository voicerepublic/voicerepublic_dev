task setup: :environment do

  fmt = '%-10s %s'

  recordings_path = Settings.rtmp.recordings_path
  recordings_path = File.expand_path(recordings_path, Rails.root)
  puts fmt % ['RECORDINGS', recordings_path]
  unless File.exist?(recordings_path)
    puts "Create #{recordings_path}"
    FileUtils.mkdir_p(recordings_path)
  end

  build_path = Settings.rtmp.build_path
  build_path = File.expand_path(build_path, Rails.root)
  puts fmt % ['RTMPBUILD', build_path]
  unless File.exist?(build_path)
    puts
    puts "Run `rake rtmp:build` first."
    puts
    exit
  end

  rectemp_path = File.expand_path('run/recordings', build_path)
  puts fmt % ["RECTEMP", rectemp_path]
  if rectemp_path == recordings_path
    puts
    puts 'Wait a minute. RECORDINGS cannot be equal to RECTEMP.'
    puts 'Plase change your settings.'
    puts
    exit
  end
  if File.directory?(rectemp_path) && !File.symlink?(rectemp_path)
    files = Dir.glob("#{rectemp_path}/*.*")
    unless files.empty?
      puts "Directory #{rectemp_path} not empty. Moving files."
      FileUtils.mv(files, recordings_path)
    end
    FileUtils.rm_rf(rectemp_path)
  end
  puts fmt % ["symlink", rectemp_path]
  puts fmt % ["     ->", recordings_path]
  FileUtils.ln_sf(recordings_path, rectemp_path)

end
