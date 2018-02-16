class ExploreController < ApplicationController

  LIMIT = 12
  layout 'velvet'

  def index
    @formats    = TagBundle.format.as_options
    @publishers = TagBundle.publisher.as_options
    @categories = TagBundle.category
    @languages  = Talk.available_languages.invert
    @all_categories = OpenStruct.new({
      id: '',
      icon:'default',
      title: I18n.t('all_categories')
    })

    page = params[:page] || 1
    @talks = Talk.popular.paginate(page: page, per_page: LIMIT)
    if filter = params[:filter]
      unless (language = filter[:language]).blank?
        @talks = @talks.where(language: language)
      end
      # TODO publisher might actually be tagged on users
      unless (publisher = filter[:publisher]).blank?
        @talks = @talks.joins(:series).where('series.user_id = ?', publisher.to_i)
      end
      # TODO format might actualy be tagged on series
      unless (format = filter[:format]).blank?
        bundle = TagBundle.find(format)
        @talks = @talks.tagged_in_bundle(bundle)
      end
      unless (category = filter[:category]).blank?
        bundle = TagBundle.find(category)
        @talks = @talks.tagged_in_bundle(bundle)
      end
    end

    if request.xhr?
      if page == 1
        # these get replaced by ajax filters
        return render partial: 'results'
      else
        # these get appended by infinite scroll
        return render partial: 'shared/talk_card', collection: @talks
      end
    end
  end

end
