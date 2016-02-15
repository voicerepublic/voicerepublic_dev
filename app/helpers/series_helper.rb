module SeriesHelper

  def talks_partial(collection)
    collection.count > 1 ? 'shared/talk_card' : 'shared/talk_card'
  end

  def talkslive_partial(collection)
    collection.count > 2 ? 'shared/talk_card' : 'shared/talk_card'
  end

  def talks_grid(collection)
    collection.count > 1 ? 'talks-small-block-grid' : 'list-style-type-none'
  end

  def talkslive_grid(collection)
    collection.count > 2 ? 'talks-small-block-grid' : 'list-style-type-none'
  end

  def social_meta_tags_series
    opts = {
      description: @series.description.empty? ?
        @series.teaser : strip_html(@series.description),
      title:    @series.title,
      image:    @series.image.url,
      keywords: @series.try(:tag_list),
      author:   @series.user.name,
      url:      series_url(@series),
      player:   { embed: false }
    }
    render_social_meta_tags(opts)
  end

end
