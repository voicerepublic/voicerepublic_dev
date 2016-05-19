# The future Bookmarks are currently called Reminders
#
class Api::BookmarksController < Api::BaseController

  MAX_LIMIT = 20

  JSON_CONFIG = {
    only: %w(
            id
            title
            teaser
            duration
            processed_at
            play_count
            language
            speaker_list
            popularity
            description_as_html
          ),
    methods: %w(
               slides_url
               media_url
               image_url
               self_url
             )
  }

  # GET /api/bookmarks
  def index
    @talks = Talk.remembered_by(current_user).archived.nodryrun

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

    render json: @talks.to_json(JSON_CONFIG)
  end

end
