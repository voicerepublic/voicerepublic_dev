class Artifact < ActiveRecord::Base

  serialize :metadata

  belongs_to :context, polymorphic: true

end
