module Category

  extend self

  # TODO rewrite to use tag bundles
  def available
    ActsAsTaggableOn::Tag.where(promoted: true).
      order('taggings_count desc').map { |t| [t.name] * 2}
  end

end
