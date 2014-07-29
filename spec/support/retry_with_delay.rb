# module for helping request specs access things that need some time to get
# there that cannot be tested using capybara.
module RetryWithDelayHelper

  def retry_with_delay(&block)
    max_tries = 25
    attempts = 0
    begin
      attempts += 1
      return block.call(attempts)
    rescue Exception => exception
      raise exception if attempts >= max_tries
      sleep 0.2
      retry
    end
  end

end

RSpec.configure do |config|
  config.include RetryWithDelayHelper
end
