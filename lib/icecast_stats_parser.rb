require 'json'
require 'open-uri'

module IcecastStatsParser

  extend self

  def call(json)
    sources = JSON.parse(json)['icestats']['source']

    # if it is not an array, we don't care
    return {} unless sources.is_a?(Array)

    # find the main source
    main = sources.find { |s| s['listenurl'].match(/\/live$/) }

    # TODO find out why main is sometimes nil
    return {} if main.nil?

    # initialize
    stats = {
      bitrate: main['audio_bitrate'],
      listener_count: 0,
      listener_peak: 0
    }

    sources = (sources - [main])

    # sum up over remaining sources
    sources.each do |source|
      stats[:listener_count] += (source['listeners'] || 0)
      stats[:listener_peak] += (source['listener_peak'] || 0)
    end

    stats
  end

  # for debugging
  def from_ip(ip)
    json = open("http://#{ip}/status-json.xsl").read
    call(json)
  rescue Exception => e
    puts "--- ERROR ---"
    puts json
    puts e
  end

  def from_ips(ips)
    ips.inject({}) do |result, ip|
      result.merge ip => from_ip(ip)
    end
  end

end
