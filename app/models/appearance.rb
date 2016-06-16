# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime] - creation time
# * talk_id [integer] - belongs to :talk
# * updated_at [datetime] - last update time
# * speaker_id [integer] - belongs to :speaker
class Appearance < ActiveRecord::Base

  validates :speaker, :talk, presence: true

  belongs_to :speaker
  belongs_to :talk

end
