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
class Setting < ActiveRecord::Base

  validates :key, :value, presence: true
  
  class << self
    def get(key)
      # try to find an entry in the db
      find_by(key: key).try(:value) ||
        # fallback Settings class provided by rails_config
        key.split('.').inject(Settings) { |r, k| r.send(k) }
    end
  end
  
end
