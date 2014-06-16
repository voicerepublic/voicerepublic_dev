# The Assimilator runs specs and reports the outcome.
#
# Runnning the Asimilator in CLI
#
#     bundle exec run lib/assimilator.rb <url> <ref> <pusher>
#
# Example params:
#
#     repo   - https://github.com/munen/voicerepublic_dev
#     ref    - refs/heads/experimental/71854768/endless-assimilation
#     pusher - phil@branch14.org
#
# For an example of an `opts` hash see `app/jobs/assimilate.rb`.
#
class Assimilator < Struct(:repo, :ref, :pusher)

  class << self
    def run(opts)
      repo   = opts['repository']['url']
      ref    = opts['ref']
      pusher = opts['pusher']['email']
      
      new(repo, ref, pusher).run
    end
  end

  def run
    logger.info("#{pusher} pushed #{ref} to #{repo}")
    # TODO git clone or pull
    # TODO bundle
    # TODO rspec spec
  end

  private
  
  def logger
    logpath = Rails.root.join('log', 'ci.log')
    logfile = File.open(logpath, 'a')
    logfile.sync = true
    Logger.new(logfile)
  end
  
end

Assimilator.new(ARGV).run if __FILE__ == $0
