class TalksController < BaseController

  include OnTheFlyGuestUser

  before_action :set_venue_and_user, except: [:index, :popular, :live, :recent,
    :featured, :upcoming]
  before_action :set_talk, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /talks/featured
  def featured
    @talks = Talk.prelive.featured.paginate(page: params[:page], per_page: 25)
    render :index
  end

  # GET /talks/upcoming
  def upcoming
    @talks = Talk.prelive.ordered.paginate(page: params[:page], per_page: 25)
    render :index
  end

  # GET /talks/popular
  def popular
    @talks = Talk.popular.paginate(page: params[:page], per_page: 25)
    render :index
  end

  # GET /talks/live
  def live
    @talks = Talk.live.paginate(page: params[:page], per_page: 25)
    render :index
  end

  # GET /talks/recent
  def recent
    @talks = Talk.recent.paginate(page: params[:page], per_page: 25)
    render :index
  end

  def index
    if @venue
      @talks = @venue.talks
    else
      @talks_live     = Talk.live.limit(5)
      @talks_featured = Talk.featured.limit(5)
      @talks_recent   = Talk.recent.limit(5)
      @talks_popular  = Talk.popular.limit(5)
    end
  end

  # GET /talks/1
  def show
    respond_to do |format|
      @related_talks = @talk.related_talks
      format.html
      format.text do
        authorize! :manage, @talk
        render text: @talk.message_history
      end
      format.png { send_file @talk.flyer.path(true) }
    end
  end

  # GET /talks/new
  def new
    @talk = Talk.new
  end

  # GET /talks/1/edit
  def edit
  end

  # POST /talks
  def create
    @talk = Talk.new(talk_params)

    # TODO: transaction

    if @venue.id.nil?
      @venue.user = @user
      @venue.save
      @user.default_venue = @venue
      @user.save
    end

    @talk.venue = @venue

    authorize! :create, @talk

    if @talk.save

      redirect_to [@venue, @talk], notice: 'Talk was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /talks/1
  def update
    authorize! :update, @talk
    if @talk.update(talk_params)
      redirect_to [@venue, @talk], notice: 'Talk was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /talks/1
  def destroy
    authorize! :destroy, @talk

    @talk.destroy
    redirect_to @venue, notice: 'Talk was successfully destroyed.'
  end

  private

  def set_venue_and_user
    # when entering the controller, either
    # venue- or user_id have to be set
    #
    if params[:user_id].nil?     # venue_id is set
      @venue = Venue.find(params[:venue_id])
      @user = @venue.user
      @came_in_via = :venue
    else                         # user_id is set
      @user = User.find(params[:user_id])
      @venue = default_venue( @user )
      @came_in_via = :user
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_talk
    @talk = Talk.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def talk_params
    params.require(:talk).permit(:title, :teaser, :starts_at_date,
                                 :starts_at_time, :duration,
                                 :description, :collect, :image,
                                 :tag_list, :guest_list, :language,
                                 :format)
  end

  # TODO: move into model
  def default_venue( user )
    return (
      if ! user.default_venue.nil?
        user.default_venue
      else
        Venue.new( title:       "My Talks",
                   teaser:      "various talks",
                   description: "Various talks, that don't belong to any particular series",
                   tag_list:    "default")
      end
    )
  end
end
