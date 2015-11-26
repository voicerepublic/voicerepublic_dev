class Page < ActiveRecord::Base

  self.inheritance_column = :_type_disabled

  serialize :title
  serialize :content_as_html

  def content
    locale = 'en' # for now
    OpenStruct.new(content_as_html[locale])
  end

  def template
    type.underscore
  end

end
