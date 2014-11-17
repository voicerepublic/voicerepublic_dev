namespace :build do
  task flash: :environment do
    # actionscript
    puts 'compiling actionscript...'
    apath = %w(lib flash Blackbox.as)
    afile = Rails.root.join(File.join(apath))
    cmd = "mxmlc #{afile}"
    %x[ #{cmd} ]

    # revision
    puts 'set revision...'
    rpath = %w(lib flash VERSION)
    rfile = Rails.root.join(File.join(rpath))
    revision = File.exist?(rfile) ? File.read(rfile).to_i : 0
    revision += 1
    File.open(rfile, 'w') { |f| f.print(revision) }
    puts
    puts "    REVISION #{revision}"
    puts

    # cleanup privous versions
    cpath = %w(app assets flash Blackbox*.swf)
    cglob = Rails.root.join(File.join(cpath))
    FileUtils.rm(Dir.glob(cglob))

    # swf -> target
    spath = %W(lib flash Blackbox.swf)
    sfile = Rails.root.join(File.join(spath))
    tpath = %W(app assets flash Blackbox#{revision}.swf)
    tfile = Rails.root.join(File.join(tpath))
    FileUtils.mv(sfile, tfile)
    %x[ git add #{tfile} ]
    puts
  end
end
