class DeviceReport < ActiveRecord::Base

  belongs_to :device
  has_many :artifacts, as: :context

  serialize :data

  scope :ordered, -> { order('created_at ASC') }
  scope :aggregated, -> { where(uptime: nil).ordered }
  scope :disaggregated, -> { where('uptime IS NOT NULL') }

  def self.disaggregate_missing!
    self.aggregated.find_each(&:disaggregate!)
  end

  FD_FIELDS = [ :memory_total,
                :disk_total,
                :users,
                :number_of_audio_devices,
                :number_of_usb_devices ]

  IND_FIELDS = [ :memory_free,
                 :memory_used,
                 :uptime,
                 :disk_available,
                 :disk_used,
                 :current_recording_size,
                 :load1,
                 :load5,
                 :load15,
                 :temperature,
                 :heartbeat_response_time,
                 :bandwidth ]

  def self.analysis
    fd = FD_FIELDS.inject({}) do |result, field|
      result.merge field => self.disaggregated.group(field).count
    end
    ind = IND_FIELDS.inject({}) do |result, field|
      result.merge field => { min: self.disaggregated.minimum(field),
                              max: self.disaggregated.maximum(field),
                              avg: self.disaggregated.average(field).to_f }
    end
    { count: self.disaggregated.count }.merge(fd).merge(ind)
  end

  def analysis
    {
      load1: load1 - self.class.disaggregated.average(:load1).to_f
    }
  end

  def disaggregate!
    _, _uptime, _users, _load1, _load5, _load15 =
      self.data['uptime'].match(UPTIME_REGEX).to_a
    # if it didn't match store it in _uptime
    self.data['_uptime'] = _uptime if _.nil?
    self.uptime = parse_uptime(_uptime)
    self.users = _users
    self.load1 = _load1
    self.load5 = _load5
    self.load15 = _load15
    self.data.delete('uptime')


    self.measured_at = self.data.delete('now')
    self.temperature = self.data.delete('temperature')
    self.heartbeat_response_time = self.data.delete('heartbeat_response_time')
    self.bandwidth = self.data.delete('bandwidth')

    self.memory_free = self.data['memory']['free']
    self.memory_total = self.data['memory']['total']
    self.memory_used = self.data['memory']['used']
    self.data.delete('memory')

    self.disk_available = self.data['disk']['avail']
    self.disk_total = self.data['disk']['total']
    self.disk_used = self.data['disk']['used']
    self.data.delete('disk')

    self.current_recording_size = current_recording['size']
    self.number_of_audio_devices = self.data['devices'].size
    self.number_of_usb_devices = self.data['usb'] && self.data['usb'].size
    self.data.delete('devices') if data['devices'] == STANDARD_DEVICES
    self.data.delete('usb') if data['usb'] == STANDARD_USB

    unless self.data['recordings'].nil?
      self.data['recordings'].each do |key, details|
        url = 's3://%s/%s/%s' % [device.bucket, device.identifier, key]
        artifact = artifacts.find_or_initialize_by(url: url, context: device)
        artifact.merge_metadata(details)
        artifact.save!
      end
      self.data.delete('recordings')
    end

    self.data.delete('id')
    self.data.delete('action')
    self.data.delete('controller')

    save!
  end

  private

  def current_recording
    return {} if data['recordings'].nil?
    data['recordings'].values.find do |r|
      r['closed'].nil? && r['deleted'].nil?
    end || {}
  end

  # TODO track boot time in a machine readable form and get rid of
  # this crutch
  def parse_uptime(_uptime)
    case _uptime
    when /^(\d+)\s+min$/ then # '6 min'
      $1.to_i
    when /^(\d+):(\d+)$/ then # '20:06'
      $1.to_i * 60 + $2.to_i
    when /^(\d+)\s+days?$/ then # '1 day', '2 days'
      $1.to_i * 60 * 24
    when /^(\d+)\s+days?,\s(\d+):(\d+)$/ then # '1 day,  2:47'
      $1.to_i * 60 * 24 + $2.to_i * 60 + $3.to_i
    when /^(\d+)\s+days?,\s(\d+)\smin$/ then # '1 day,  6 min'
      $1.to_i * 60 * 24 + $2.to_i
    else -1
    end
  end

  UPTIME_REGEX = /up\s+(.+?),\s+(\d+)\s+users,\s+load\s+average:\s+([\d.]+),\s+([\d.]+),\s+([\d.]+)/

  STANDARD_DEVICES =
    {"default:CARD=CODEC"=>
     ["USB AUDIO  CODEC, USB Audio", "Default Audio Device"],
     "dmix:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio", "Direct sample mixing device"],
     "dsnoop:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio", "Direct sample snooping device"],
     "front:CARD=CODEC,DEV=0"=>["USB AUDIO  CODEC, USB Audio", "Front speakers"],
     "hw:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio",
      "Direct hardware device without any conversions"],
     "iec958:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio", "IEC958 (S/PDIF) Digital Audio Output"],
     "null"=>["Discard all samples (playback) or generate zero samples (capture)"],
     "plughw:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio",
      "Hardware device with all software conversions"],
     "surround21:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio",
      "2.1 Surround output to Front and Subwoofer speakers"],
     "surround40:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio",
      "4.0 Surround output to Front and Rear speakers"],
     "surround41:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio",
      "4.1 Surround output to Front, Rear and Subwoofer speakers"],
     "surround50:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio",
      "5.0 Surround output to Front, Center and Rear speakers"],
     "surround51:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio",
      "5.1 Surround output to Front, Center, Rear and Subwoofer speakers"],
     "surround71:CARD=CODEC,DEV=0"=>
     ["USB AUDIO  CODEC, USB Audio",
      "7.1 Surround output to Front, Center, Side, Rear and Woofer speakers"],
     "sysdefault:CARD=CODEC"=>
     ["USB AUDIO  CODEC, USB Audio", "Default Audio Device"]}

  STANDARD_USB =
    ["Bus 001 Device 004: ID 08bb:29c2 Texas Instruments PCM2902C Audio CODEC"]

end
