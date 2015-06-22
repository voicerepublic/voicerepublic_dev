class VenuesController < BaseController

  before_filter :store_location
  before_filter :authenticate_user!, :except => [:show, :tags]
  before_filter :set_venue, only: [:show, :edit, :update, :destroy]

  # GET /venues/1
  # GET /venues/1.json
  def show
    respond_to do |format|
      format.html do
        @upcoming_talks = @venue.talks.prelive.ordered
        @archived_talks = @venue.talks.archived.ordered
        @live_talks = @venue.talks.live.ordered

        if current_user
          @participation =
            @venue.participations.find_by(user_id: current_user.id)

          @show_join = @participation.nil? &&
                       current_user != @venue.user
        end

        @total_plays = @venue.talks.sum(:play_count)
      end
      format.json { render json: @venue }
      format.rss do
        talks = @venue.talks.archived.ordered
        @podcast = OpenStruct.new(talks: talks)
      end
      format.ics
    end
  end

  # GET /venues/new
  # GET /venues/new.json
  def new
    @venue = Venue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    authorize! :edit, @venue
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(venue_params)
    @venue.user = current_user

    authorize! :create, @venue

    respond_to do |format|
      if @venue.save
        format.html do
          logger.debug("Venues#cretae  - redirecting to venue")
          redirect_to @venue, notice: 'Venue was successfully created.'
         end
        format.json { render json: @venue, status: :created, location: @venue }
      else
        logger.error("Venues#create - ERROR: #{@venue.errors.inspect}")
        format.html { render action: "new" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
    authorize! :update, @venue

    respond_to do |format|
      if @venue.update_attributes(venue_params)
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    authorize! :destroy, @venue

    @venue.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
    end
  end

  private

  def remember_location # TODO: check if needed
    logger.debug("Venues#remember_location - storing location: " +
                 "#{venue_url(:id => params[:venue_id])}")
    session[:venue_path] = venue_url(:id => params[:venue_id])
  end

  def set_venue
    @venue = Venue.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def venue_params
    params.require(:venue).permit(:title, :teaser, :description,
                                  :image, :tag_list)
  end

end
