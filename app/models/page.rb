class Page < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  self.inheritance_column = :_type_disabled

  serialize :title, JSON
  serialize :content_as_html, JSON

  # this provides a nifty short cut for sections
  #
  # e.g.
  #
  #   page.content_as_html['en']['main']
  #
  # via shortcut
  #
  #   page.content.main
  #
  def content
    locale = 'en' # for now
    OpenStruct.new(content_as_html[locale])
  end

  def template
    type.underscore
  end

  private

  def title_en
    title['en']
  end

  # this codebase will never have to generate slugs!
  def slug_candidates
    [ :title_en ]
  end

end
