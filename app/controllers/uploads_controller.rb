class UploadsController < BaseController

  before_action :authenticate_user!
  before_action :redirect_if_low_on_credits, only: :new

  def new
    attrs = params[:talk] ? talk_params : {}
    attrs[:venue_id] ||= current_user.default_venue_id
    @talk = Talk.new(attrs)
  end

  # POST /uploads
  def create
    @talk = Talk.new(talk_params)
    @talk.venue_user = current_user

    authorize! :create, @talk

    if @talk.save
      redirect_to @talk, notice: 'Talk was successfully created.'
    else
      render action: 'new'
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def talk_params
    params.require(:talk).permit(:title, :teaser, :starts_at_date,
                                 :starts_at_time,
                                 :description, :image,
                                 :tag_list, :language,
                                 :new_venue_title, :venue_id,
                                 :user_override_uuid, :slides_uuid)
  end

end
