class Api::TalksController < Api::BaseController

  MAX_LIMIT = 20

  JSON_CONFIG = {
    # TODO `only` is generally better than `except`, to not leak data
    except: %w( session
                storage
                image_uid
                edit_config
                penalty
                slides_uuid
                recording_override
                listeners
                social_links
                dryrun
                user_override_uuid
                series_id
                slides_uid )
  }

  # GET /api/talks
  def index
    @talks = Talk.all

    # paging
    limit = [params[:limit].to_i, MAX_LIMIT].min
    limit = MAX_LIMIT if limit == 0
    @talks = @talks.limit(limit)
    @talks = @talks.offset(params[:offset].to_i) if params[:offset]

    # sort order
    if order = params[:order] and Talk.column_names.include?(params[:order])
      order = "#{order} DESC" if params[:reverse]
      @talks = @talks.order(order)
    end

    # filter
    @talks = @talks.where.not(featured_from: nil) if params[:featured_from]
    @talks = @talks.where(state: params[:state]) if params[:state]

    render json: @talks.to_json(JSON_CONFIG)
  end

end
