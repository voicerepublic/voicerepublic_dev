class TalksController < ApplicationController

  before_action :set_venue, except: [:index, :popular, :live, :recent, :featured]
  before_action :set_talk, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /talks/popular
  def featured
    @talks = Talk.prelive.paginate(page: params[:page], per_page: 25)
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

  # GET /talks/archived
  def recent
    @talks = Talk.recent.paginate(page: params[:page], per_page: 25)
    render :index
  end  

  def index
    @talks_live     = Talk.live.limit(5)
    @talks_featured = Talk.featured.limit(5)
    @talks_recent   = Talk.recent.limit(5)
    @talks_popular  = Talk.popular.limit(5)
  end

  # GET /talks/1
  def show
    respond_to do |format|
      format.html
      format.text do
        authorize! :manage, @talk
        render text: @talk.message_history
      end
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
    @talk.venue = @venue

    if @talk.save
      redirect_to [@venue, @talk], notice: 'Talk was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /talks/1
  def update
    if @talk.update(talk_params)
      redirect_to [@venue, @talk], notice: 'Talk was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /talks/1
  def destroy
    @talk.destroy
    redirect_to @venue, notice: 'Talk was successfully destroyed.'
  end

  private

  def set_venue
    @venue = Venue.find(params[:venue_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_talk
    @talk = Talk.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def talk_params
    params.require(:talk).permit(:title, :teaser, :starts_at_date,
                                 :starts_at_time, :duration,
                                 :description, :record, :image,
                                 :tag_list, :guest_list)
  end

end
