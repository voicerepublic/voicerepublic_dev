class Api::TalksController < Api::BaseController

  skip_before_action :verify_authenticity_token, if: lambda { request.format.json? }

  MAX_LIMIT = 20

  JSON_CONFIG = {
    except: %w( session
                storage
                image_uid
                grade
                edit_config
                penalty
                slides_uuid
                recording_override
                listeners)
  }

  before_action :authenticate_user!

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
