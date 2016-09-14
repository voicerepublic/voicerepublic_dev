class DeviceReport < ActiveRecord::Base
  belongs_to :device

  serialize :data
end
