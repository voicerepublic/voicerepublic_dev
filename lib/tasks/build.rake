namespace :build do
  task flash: :environment do
    # actionscript
    puts 'compiling actionscript...'
    apath = %w(lib flash BlackboxUI.mxml)
    afile = Rails.root.join(File.join(apath))
    cmd = "mxmlc #{afile}"
    %x[ #{cmd} ]

    exit if $?.exitstatus > 0

    # revision
    puts 'compiled successfully, set revision...'
    rpath = %w(lib flash VERSION)
    rfile = Rails.root.join(File.join(rpath))
    revision = File.exist?(rfile) ? File.read(rfile).to_i : 0
    revision += 1
    File.open(rfile, 'w') { |f| f.print(revision) }
    puts
    puts "    REVISION #{revision}"
    puts

    # cleanup privous versions
    cpath = %w(public flash Blackbox*.swf)
    cglob = Rails.root.join(File.join(cpath))
    FileUtils.rm(Dir.glob(cglob))

    # swf -> target
    spath = %W(lib flash BlackboxUI.swf)
    sfile = Rails.root.join(File.join(spath))
    tpath = %W(public flash Blackbox#{revision}.swf)
    tfile = Rails.root.join(File.join(tpath))
    FileUtils.mv(sfile, tfile)
    %x[ git add #{tfile} ]
    puts
  end

  task sitemap: :environment do
    %x[ curl -k #{Settings.sitemap} > public/sitemap.xml ]
  end
end
