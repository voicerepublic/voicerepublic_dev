class TagBundle < ApplicationRecord

  GROUPS = %w( category publisher format profession )

  GROUPS.each do |group|
    scope group.to_sym, -> { where(group: group) }
  end

  scope :standalone, -> { where(group: nil) }
  scope :promoted, -> { where(promoted: true) }
  scope :as_options, -> { pluck("title_#{I18n.locale}", :id, :icon) }

  acts_as_taggable

  # poor man's globalize
  def title
  	send("title_#{I18n.locale}")
  end

  def description
  	send("description_#{I18n.locale}")
  end

end
