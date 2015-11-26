class Page < ActiveRecord::Base

  self.inheritance_column = :_type_disabled

  serialize :title, JSON
  serialize :content_as_html, JSON

  def content
    locale = 'en' # for now
    OpenStruct.new(content_as_html[locale])
  end

  def template
    type.underscore
  end

end
