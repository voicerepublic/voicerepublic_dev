class DeviceReport < ActiveRecord::Base

  UPTIME_REGEX = /up\s+(.+?),\s+(\d+)\s+users,\s+load\s+average:\s+([\d.]+),\s+([\d.]+),\s+([\d.]+)/

  belongs_to :device

  serialize :data

  scope :aggregated, -> { where(load1: nil) }
  scope :disaggregated, -> { where('load1 IS NOT NULL') }

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
    self.uptime = parse_uptime(_uptime)
    self.users = _users
    self.load1 = _load1
    self.load5 = _load5
    self.load15 = _load15
    #self.data.delete('uptime')

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

    #self.data['recordings'].each do |key, details|
    #  url =
    #end

    self.data.delete('id')
    self.data.delete('action')
    self.data.delete('controler')

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
  #
  # TODO
  # "12:19:31 up 1 day, 6 min,  0 users,  load average: 0.00, 0.01, 0.05"
  # "15:00:33 up 1 day,  2:47,  0 users,  load average: 0.00, 0.01, 0.05"
  def parse_uptime(_uptime)
    case _uptime
    when /^(\d+)\s+min$/ then $1.to_i
    when /^(\d+):(\d+)$/ then $1.to_i * 60 + $2.to_i
    when /^(\d+)\s+days?$/ then $1.to_i * 60 * 24
    else -1
    end
  end

end
