# Fetches the first tar.gz from these pages
#
#  * http://nginx.org/en/download.html
#  * https://github.com/arut/nginx-rtmp-module/releases
#
# Needless to say that this might break sometime.
#
namespace :rtmp do

  task :setup => :environment do
    path = Rails.root.join(settings.build_path)
    unless File.exist?(path)
      FileUtils.mkdir_p(path)
      puts "created directory #{path}"
    end
    Dir.chdir(path)
  end

  desc 'retrieve and build the newest nginx-rtmp server'
  task :build, [:repo] => :setup do |t, args|
    puts 'checking for nginx...'
    nginx_path = retrieve('http://nginx.org', '/en/download.html')

    repo = args[:repo] || 'arut/nginx-rtmp-module'
    puts "checking for nginx-rtmp-module... (#{repo})"
    rtmp_path = retrieve('https://github.com', "/#{repo}/releases")

    version = nginx_path + '/' + rtmp_path
    puts "compiling (#{version})..."
    Dir.chdir(nginx_path) do
      %x[ ./configure --prefix='' --add-module=../#{rtmp_path} ]
      # make nginx Makefile more permissive (might fail on MacOS)
      puts cmd = "sed -ie 's/-Werror //' objs/Makefile"
      %x[ #{cmd} && make ]
    end
    FileUtils.cp(rtmp_path+'/stat.xsl', '.') # untested
    FileUtils.mkdir_p('run/logs')
    FileUtils.mkdir_p('run/recordings')
    FileUtils.ln_sf('../' + nginx_path + '/objs/nginx', 'run/rtmpd')
    puts
    puts "Good news everyone. You're all set."
    puts
    puts '  rake rtmp:(start|stop|restart)'
    puts
  end

  desc 'generates the rtmp config based on template and settings'
  task :config => :setup do
    template = File.read(Rails.root.join('config/rtmp.conf.erb'))
    File.open('run/rtmp.conf', 'w') do |f|
      f.puts render_erb(template, settings.to_hash)
    end
  end

  desc 'start the nginx-rtmp server (also generates config)'
  task :start => :config do
    %x[ cd run && ./rtmpd -c rtmp.conf ]
    pids = %x[ pgrep rtmpd ].split("\n")
    puts "rtmpd started with pids #{pids * ', '}"
  end

  desc 'stop the nginx-rtmp server'
  task :stop => :setup do
    %x[ cd run && ./rtmpd -c rtmp.conf -s stop ]
  end

  desc 'restart the nginx-rtmp server'
  task :restart => [:stop, :start]

  task :clobber => :setup do
    FileUtils.rm_rf Rails.root.join(settings.build_path)
  end

  # TODO
  #task :log => :setup do
  #  %x[ tail -f run/logs/access.log run/logs/error.log ]
  #end

  def retrieve(base, page)
    releases = base + page
    dom = Nokogiri::HTML(open(releases).read)
    link = dom.xpath("//a[contains(@href, '.tar.gz')]").first
    url = base + link[:href]
    file = File.basename(url)
    unless File.exist?(file)
      puts "fetching newest version (#{file.sub('.tar.gz','')})..."
      %x[ wget -q '#{url}' ]
    end
    output = %x[ tar xfvz #{file} ]
    output.split('/').first
  end

  def render_erb(template, locals)
    ERB.new(template).result(OpenStruct.new(locals).instance_eval { binding })
  end

  def settings
    Settings.reload!.rtmp
  end

end
