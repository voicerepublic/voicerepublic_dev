# Fetches the first tar.gz from these pages
#
#  * http://nginx.org/en/download.html
#  * https://github.com/arut/nginx-rtmp-module/releases
#
# Needless to say that this might break sometime.
#
namespace :rtmp do

  task :setup => :environment do
    path = Rails.root.join('vendor/rtmp')
    unless File.exist?(path)
      FileUtils.mkdir_p(path) 
      puts "created directory #{path}"
    end
    Dir.chdir(path)
  end

  desc 'retrieve and build the newest nginx-rtmp server'
  task :build => :setup do
    puts 'checking for nginx...'
    nginx_path = retrieve('http://nginx.org', '/en/download.html')
    puts 'checking for nginx-rtmp-module...'
    rtmp_path = retrieve('https://github.com', '/arut/nginx-rtmp-module/releases')
    version = nginx_path + '/' + rtmp_path
    puts "compiling (#{version})..."
    Dir.chdir(nginx_path) do
      %x[ ./configure --prefix='' --add-module=../#{rtmp_path} && make ]
    end
    FileUtils.mkdir_p('./run/recordings')
    FileUtils.ln_sf('../' + nginx_path + '/objs/nginx', 'run/rtmpd')
    puts 
    puts "Good news everyone. You're all set."
    puts
    puts '  rake rtmp:(start|stop|restart)'
    puts
  end

  desc 'start the nginx-rtmp server'
  task :start => :setup do
    config = Rails.root.join('config/rtmp.conf')
    %x[ mkdir -p run/logs && cd run && ./rtmpd -c #{config} ]
    pids = %x[ pgrep rtmpd ].split("\n")
    puts "rtmpd started with pids #{pids * ', '}"
  end

  desc 'stop the nginx-rtmp server'
  task :stop => :setup do
    config = Rails.root.join('config/rtmp.conf')
    %x[ mkdir -p run/logs && cd run && ./rtmpd -c #{config} -s stop ]
  end

  desc 'restart the nginx-rtmp server'
  task :restart => [:stop, :start]

  task :clobber => :setup do
    FileUtils.rm_rf Rails.root.join('vendor/rtmp')
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

end
