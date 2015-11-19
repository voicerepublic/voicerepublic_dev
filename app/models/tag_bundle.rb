class TagBundle < ActiveRecord::Base

  acts_as_taggable

  def talks
    Talks.tagged_with(tag_list, any: true)
  end

end
