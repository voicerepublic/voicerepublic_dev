class TagBundle < ActiveRecord::Base

  GROUPS = %w( category publisher format profession )

  GROUPS.each do |group|
    scope group.to_sym, -> { where(group: group) }
  end

  scope :standalone, -> { where(group: nil) }
  scope :promoted, -> { where(promoted: true) }

  acts_as_taggable

  # poor man's globalize
  def title
  	send("title_#{I18n.locale}")
  end

  def description
  	send("description_#{I18n.locale}")
  end

end
