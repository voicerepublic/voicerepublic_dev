module Category

  extend self

  def available
    ActsAsTaggableOn::Tag.where(category: true).
      order('taggings_count desc').map { |t| [t.name] * 2}
  end

end
