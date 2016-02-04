require 'open-uri'

require 'yaml' # active_support needs it
require 'active_support'
require 'active_support/core_ext'

require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

# q:site_observer -> x:sites_observed
class SiteObserver

  include Services::Subscriber
  include Services::Publisher

  DELAY = 4 # 4 seconds
  STRIKES = 3 # and you're out

  subscribe q: 'site_observer'

  attr_accessor :sites, :failed

  def initialize
    self.sites = []
    self.failed = {}
  end

  def run
    @thread = Thread.new do
      loop do
        observe
        sleep DELAY
      end
    end
    @thread.run

    super # Services::Subscriber#run
  end

  def site_observer(*args)
    body = args.shift
    url = body['url']
    self.sites |= [url]
    self.failed[url] = 0
  end

  def observe
    t_0 = Time.now.to_i

    details = sites.inject({}) do |result, url|
      begin
        xml = open(url).read
        site = Hash.from_xml(xml)
        result.merge url => site
        self.failed[url] = 0
      rescue
        self.failed[url] += 1
        # remove site from list if connection fails STRIKES
        # consecutive times
        if self.failed[url] == STRIKES
          self.sites.delete(url)
          self.failed.delete(url)
        end
      end
      result
    end

    delta_t = Time.now.to_i - t_0
    publish x: 'sites_observed', sites: details,
            freq: DELAY, duration: delta_t
  end

end
