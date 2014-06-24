#!/usr/bin/env ruby

require 'logger'
require 'fileutils'
require 'json'

# The Assimilator runs specs and reports the outcome.
#
# Runnning the Asimilator in CLI
#
#     bundle exec run lib/assimilator.rb <repo> <ref> <pusher>
#
# Example params:
#
#     repo   - https://github.com/munen/voicerepublic_dev
#     ref    - refs/heads/feature/73378326/insider-log
#     sha    - 2f00d0a2539fd04194ef0a6944166fe15e1299f6
#     pusher - phil@branch14.org
#
# Example invocation:
#
#     ./lib/assimilator.rb https://github.com/munen/voicerepublic_dev refs/heads/feature/73378326/insider-log 2f00d0a2539fd04194ef0a6944166fe15e1299f6 phil@branch14.org
#
# For an example of an `opts` hash see `app/jobs/assimilate.rb`.
#
# See end of file for documentation on setup.
#
class Assimilator < Struct.new(:repo, :ref, :sha, :pusher)

  STATES = %w( pending success error failure )

  class << self
    def run(opts)
      repo   = opts['repository']['url']
      ref    = opts['ref']
      sha    = opts['after']
      pusher = opts['pusher']['email']
      
      new(repo, ref, sha, pusher).run
    end
  end

  def run
    die 'missing argument "repo"'   unless repo
    die 'missing argument "ref"'    unless ref
    die 'missing argument "sha"'    unless sha
    die 'missing argument "pusher"' unless pusher

    gitrepo = repo.sub 'https://github.com/', 'git@github.com:'
    gitref = ref.sub 'refs/heads/', ''
    
    logger.info("#{pusher} pushed #{ref} to #{repo}")

    # TODO also set a status when scheduling dj
    status('pending', "preparing to run specs...")
    
    puts Dir.pwd
    # TODO make configurable
    path = '/home/app/app/shared/ci'
    # TODO remove hack
    path = '/tmp/ci' if %x[hostname].chomp == 'fatou'
    path = File.expand_path(path, Dir.pwd) 
    FileUtils.mkdir_p(path, verbose: true) unless File.exist?(path)
    puts "cd #{path}"
    Dir.chdir(path)
    # git clone or pull
    unless File.exist?('repo')
      execute "git clone #{gitrepo} repo"
      Dir.chdir('repo')
    else
      Dir.chdir('repo')
      execute "git checkout master; git pull"
    end
    # git checkout <sha>
    execute "git checkout #{sha}"
    # bundle
    execute "bundle"
    # setup
    # TODO make configurable
    dbname = 'rails_test'
    # TODO remove hack
    dbname = 'vr_ci' if %x[hostname].chomp == 'fatou'
    File.open('config/database.yml', 'w') do |f|
      f.puts <<-EOF
test:
  adapter: postgresql
  encoding: unicode
  database: #{dbname}
      EOF
    end
    execute 'bundle exec rake db:migrate RAILS_ENV=test'
    # rspec spec
    status('pending', "running specs...")
    # TODO make configurable
    execute "bundle exec rspec spec --fail-fast", false
    # report
    status($?.exitstatus > 0 ? 'failure' : 'success')
  end

  private

  # TODO make configurable, use this to set your token
  def token
    '9be52839439e988795337962ef388b9e61194fcd'
  end
  
  def status(state, descr='')
    raise "invalid state: #{state}" unless STATES.include?(state)
    logger.info("status: #{state} (#{descr})")
    auth = "#{token}:x-oauth-basic"
    url = "https://api.github.com/repos/munen/voicerepublic_dev/statuses/#{sha}"
    payload = {
      state: state,
      description: descr,
      context: 'endless-assimilation'
    }
    curl = "curl -s -u #{auth} -d '#{JSON.unparse(payload)}' #{url} > /dev/null"
    system curl
  end
  
  def execute(cmd, safe=true)
    puts "$ #{cmd}"
    system cmd
    rv = $?.exitstatus
    die "exited with #{rv}" if safe && rv > 0
  end
  
  def die(msg)
    status('error', msg)
    puts "Abort: #{msg}"
    exit 1
  end
  
  def logger
    return @logger unless @logger.nil?
    logpath = File.expand_path('../../log/ci.log', __FILE__)
    logfile = File.open(logpath, 'a')
    logfile.sync = true
    @logger = Logger.new(logfile)
  end
  
end

Assimilator.new(*ARGV).run if __FILE__ == $0

# TODO improve setup documentation
#
# As root
#
#     [13:59:18] voicerepublic-staging:~# su - postgres
#     [13:59:18] voicerepublic-staging:~$ createdb rails_test
#     [13:59:18] voicerepublic-staging:~$ psql rails_test
#     psql (9.1.11)
#     Type "help" for help.
#
#     rails_production=# CREATE EXTENSION pg_trgm;
#     CREATE EXTENSION
#     rails_production=# CREATE EXTENSION unaccent;
#     CREATE EXTENSION
              
