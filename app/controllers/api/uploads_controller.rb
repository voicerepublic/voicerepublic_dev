class Api::UploadsController < Api::BaseController

  # POST /api/uploads
  def create
    unless current_user.credits > 0
      render json: { errors:  I18n.t('low_on_credits')},
        status: 402 and return
    end

    @talk = Talk.new(talk_params)
    @talk.series_user = current_user
    @talk.series_id ||= current_user.default_series_id
    @talk.venue_id ||= current_user.default_venue_id

    # TODO security: I think here we can inject talks into any series or venue!

    authorize! :create, @talk

    if @talk.save
      render json: @talk.to_json
    else
      render json: { errors: @talk.errors }, status: 422
    end
  end

  private

  def talk_params
    params.require(:talk).permit(:title, :teaser, :starts_at_date,
                                 :starts_at_time,
                                 :description, :image,
                                 :tag_list, :language,
                                 :new_series_title, :series_id,
                                 :new_venue_name, :venue_id,
                                 :user_override_uuid)
  end

end
