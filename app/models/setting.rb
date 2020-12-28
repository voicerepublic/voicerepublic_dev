# Setting overrides settings provided via rails_config
#
# Wherever it makes sense to have a setting available to change during
# runtime (without deployment) use `Setting` instead of `Settings`.
#
# Usage:
#
#   Setting.get('audio.process_chain')
#
# as opposed (but falls back) to
#
#   Settings.audio.process_chain
#

# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime] - creation time
# * key [string] - TODO: document me
# * updated_at [datetime] - last update time
# * value [string] - TODO: document me
class Setting < ApplicationRecord

  validates :key, :value, presence: true

  class << self
    def get(key)
      # try to find an entry in the db
      find_by(key: key).try(:value) ||
        # fallback Settings class provided by rails_config
        key.split('.').inject(Settings) { |r, k| r.send(k) }
    end

    def set(key, value)
      create key: key, value: value
    end
  end
  
end
