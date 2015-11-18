class Page < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def title
    title_en
  end

  def content_as_html
    content_en_as_html
  end

  private

  # this codebase will never have to generate slugs!
  def slug_candidates
    [ :title_en ]
  end

end
