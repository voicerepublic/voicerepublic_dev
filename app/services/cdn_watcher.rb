require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)
require 'faraday' 

class CdnWatcher

  include Services::Publisher

  DELAY = 60 # every minute
  CDN_RESOURCES = ['http://ccloud.webtype.com/css/fa41b746-9201-4f1c-ab4a-a330eb0afb96.css']
  OK = 200

  def run
    loop do
      cdn_results = CDN_RESOURCES
                      .map { |res| {resource: res,
                                               status: Faraday.new(:url => res).get('/').status}}
                      .select { |cdn| cdn[:status] != OK }
      puts cdn_results
                                                
      publish x: 'cdn_status', cdn_status: cdn_results 
      sleep DELAY
    end
  end

end

# SERVICE CdnWatcher 
# -> cdn_status 
