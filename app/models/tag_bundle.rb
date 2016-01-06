class TagBundle < ActiveRecord::Base

  GROUPS = %w( category publisher format profession )

  GROUPS.each do |group|
    scope group.to_sym, -> { where(group: group) }
  end

  scope :standalone, -> { where(group: nil) }

  scope :as_options, -> { pluck("title_#{I18n.locale}", :id, :icon) }

  scope :promoted, -> { where(promoted: true) }

  acts_as_taggable

end
