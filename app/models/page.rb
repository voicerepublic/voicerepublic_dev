class Page < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  self.inheritance_column = :_type_disabled

  has_many :sections

  def section(key)
    locale = 'de' # for now
    section = sections.find_by(locale: locale, key: key.to_s)
    return nil if section.nil?
    section.content_as_html.try(:html_safe)
  end

  def template
    type.underscore
  end

  private

  def method_missing(method, *args)
    content = section(method)
    return content unless content.nil?
    super
  end

  def title_en
    title['en']
  end

  # this codebase will never have to generate slugs!
  def slug_candidates
    [ :title_en ]
  end

end
