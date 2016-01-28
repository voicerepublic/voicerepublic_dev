#!/usr/bin/env ruby

# https://github.com/taylorbrooks/closeio

# Run with
#
#   ruby lib/techne.rb run

require 'daemons'
require 'bunny'
require 'json'
require 'closeio'

class Techne

  attr_accessor :bunny, :channel, :apikey

  def initialize(args)
    self.bunny = Bunny.new read_timeout: 10, heartbeat: 10
    bunny.start
    self.channel = bunny.create_channel
    self.apikey = args.first
  end

  def run
    queue = channel.queue('closeio')

    puts 'Receiving from queue closeio...'
    queue.subscribe(block: true) do |info, prop, body|
      msg = JSON.parse(body)
      handle(msg)
    end
  end

  def handle(msg)
    email = msg['email']

    response = closeio.list_leads("email:#{email}")
    case response.total_results
    when 0 # no hit, create?
      lead = closeio.create_lead(
        name: "TODO Bluth Company",
        contacts: [{
                     name: "TODO Buster Bluth",
                     emails: [{type: "office", email: email}]
                   }]
      )
    when 1 # one hit add note, task & opportunity
      lead = response.data.first
      #closeio.create_note(
      #  lead_id: lead.id,
      #  note: 'Payed user account dropped under 3 credits.'
      #)
    else # multiple hits, merge?
      lead = response.data.first
    end

    closeio.create_task(
      _type: 'lead',
      lead_id: lead.id,
      assigned_to: 'user_GE4oOiEGrcdRMxOLEE1OWxcBZKYME9KJIx3X3voDZaK', # Henrik
      text: 'Time for another sale. (Dropped under 3 credits.)',
      date: today,
      is_complete: false
    )
  end

  def closeio
    @closeio ||= Closeio::Client.new(apikey)
  end

  # TODO 3 days from now
  def today
    Time.now.strftime('%Y-%m-%d')
  end

end

if __FILE__ == $0
  # daemonize
  base = File.expand_path('../..', __FILE__)
  piddir = File.join(base, 'tmp', 'pids')
  Daemons.run_proc(File.basename(__FILE__), dir: piddir) do
    Dir.chdir(base)
    Techne.new(ARGV).run
  end
end

user_GE4oOiEGrcdRMxOLEE1OWxcBZKYME9KJIx3X3voDZaK

# #curl -XGET "https://app.close.io/api/v1/contact/?_fields=id,emails" -u a1f3009f117cfe474a99435f2f1a8450b90897ddcf497322bba3ee81:
# #curl -XGET "https://app.close.io/api/v1/lead/?query=dan.cole%40clarion" -u a1f3009f117cfe474a99435f2f1a8450b90897ddcf497322bba3ee81:
#
# require 'uri'
#
# class CloseIO
#
#   APIKEY = 'a1f3009f117cfe474a99435f2f1a8450b90897ddcf497322bba3ee81'
#   ENDPOINT = 'https://app.close.io/api/v1'
#
#   def lead(query)
#     '/lead/?query=' + URI.escape(query)
#   end
#
#   def faraday
#     @faraday ||= Faraday.new(url: ENDPOINT) do |faraday|
#       #faraday.request  :url_encoded             # form-encode POST params
#       faraday.response :logger                  # log requests to STDOUT
#       faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
#     end
#   end
#
#   def list(query)
#     limit =
#     faraday.get
#   end
# response = conn.get '/nigiri/sake.json'     # GET http://sushi.com/nigiri/sake.json
# response.body
#
# conn.get '/nigiri', { :name => 'Maguro' }   # GET http://sushi.com/nigiri?name=Maguro
#
# end
