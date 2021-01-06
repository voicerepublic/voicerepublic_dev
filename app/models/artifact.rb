class Artifact < ApplicationRecord

  serialize :metadata

  belongs_to :context, polymorphic: true

  before_save :disaggregate

  def disaggregate
    self.size = self.metadata.delete('size')
  end

  def merge_metadata(details)
    if self.metadata.nil? or self.size.nil? or details['size'] > self.size
      self.metadata = details
    end
  end

end
