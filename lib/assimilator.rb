#!/usr/bin/env ruby

require 'logger'
require 'fileutils'
require 'json'
require File.expand_path('../email', __FILE__)

# http://stackoverflow.com/questions/3192128
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

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
      execute "rm -f db/schema.rb"
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

    cleanup_processes
    # start xserver for selenium
    execute 'Xvfb :1 -screen 0 1440x1080x24+32 > /dev/null 2>&1 &'

    execute 'bundle exec rake db:migrate',
      { 'RAILS_ENV' => 'test' }

    # explicitly set home, to work in Bundler.with_clean_env
    home = '/home/app'
    home = '/home/phil' if %x[hostname].chomp == 'fatou'
    ENV['HOME'] = home

    # set PATH
    ENV['PATH'] = [ ENV['PATH'],
                    "#{home}/bin",
                    '/usr/local/bin' ].compact * ':'

    # rspec spec
    status('pending', "running specs...")

    ENV['RAILS_ENV'] = 'test'

    # TODO make configurable
    output = execute("bundle exec rspec spec --fail-fast",
                     { 'RAILS_ENV' => 'test',
                       'DISPLAY' => ':1',
                       'CI' => 'assimilator' }, false)

    # report
    if $?.exitstatus > 0
      reason = 'no reason given'
      pattern = /^rspec \.\/(.*)$/
      md = output.match(pattern)
      reason = md.to_a.pop if md
      status 'failure', reason
      logger.error "Specs failed with:\n" + build_cmd + "\n" + output
      Email.send pusher, body: output, subject: "Failure: #{reason}"
    else
      status 'success'
    end

    cleanup_processes
  end

  private

  # these processes stick around if not explicitly killed
  def cleanup_processes
    execute 'killall -9 Xvfb'
    execute 'killall phantomjs'
    execute 'killall chromedriver'
  end

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

  def execute(cmd, env_vars={}, safe=true)
    puts "$ #{cmd}"
    env_vars.each { |k, v| ENV[k] = v }
    puts res = %x[#{cmd} 2>&1]
    logger.info "$ #{cmd}\n" + res
    res
  end

  def build_cmd
    ['./lib/assimilator.rb', repo, ref, sha, pusher] * ' '
  end

  def die(msg)
    status('error', msg)
    puts errormsg = "Abort: #{msg}"
    logger.error errormsg + "\n" + build_cmd
    cleanup_processes
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
#     rails_test=# CREATE EXTENSION pg_trgm;
#     CREATE EXTENSION
#     rails_test=# CREATE EXTENSION unaccent;
#     CREATE EXTENSION
