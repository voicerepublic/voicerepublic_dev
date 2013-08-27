class VenuesController < ApplicationController

  before_filter :store_location
  #before_filter :remember_location, :only => [:join_venue]
  before_filter :authenticate_user!, :except => [:index, :show, :tags]
  
  # GET /venues
  # GET /venues.json
  def index
    # FIXME these are horrible hacks!
    @venues      = Event.joins(:venue).not_past.upcoming_first.map(&:venue).uniq
    @past_venues = Event.joins(:venue).past.most_recent_first.limit(15).map(&:venue).uniq

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @venues }
    end
  end

  # GET /venues/1
  # GET /venues/1.json
  def show
    @venue = Venue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/new
  # GET /venues/new.json
  def new

    @venue = Venue.new
    @venue.events.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
    if params[:renew]
      @renew = true
    end
    authorize! :edit, @venue
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(params[:venue])
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
    @venue = Venue.find(params[:id])
    authorize! :update, @venue
    
    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        if params[:renew] && @venue.next_event.present?
          logger.debug("Venues#update - updating just the start time - notify others")
          Venue.generate_renew_info_for(@venue)
        end
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # # POST /venues/1/join_venue/5
  # #
  # def join_venue
  #   
  #   logger.debug("Venues#join_venue - at start of function ####################### ")
  #   
  #   @venue = Venue.find(params[:venue_id])
  #   
  #   if current_user.no_kluuus.empty?
  #     klu = current_user.no_kluuus.create(:title => current_user.name, :published => true, :tag_list => "kluser", :category => Category.first)
  #   else
  #     klu = current_user.no_kluuus.first
  #   end
  #   
  #   #klu = Klu.find(params[:klu_id])
  #   
  #   venue_klu = VenueKlu.new(:venue => @venue, :klu => klu )
  #   
  #   authorize! :create, venue_klu
  #   
  #   respond_to do |format|
  #     if venue_klu.save
  #       format.html { redirect_to @venue, notice: "Successfully joined venue" }
  #       format.json { head :no_content }
  #     else
  #       format.html { redirect_to @venue, alert: "Wasn't not able to join venue - perhaps already subscribed?" }
  #       format.json { head :no_content }
  #     end
  #   end
  # end
  # 
  # def unjoin_venue
  #   @venue = Venue.find(params[:venue_id])
  #   @venue.venue_klus.collect { |vk| vk.destroy if vk.klu.user == current_user }
  #   
  #   respond_to do |format|
  #     format.html { redirect_to @venue, notice: "Successfully unjoined venue" }
  #     #format.js {}
  #   end
  # end
  
  def new_join
    @venue = Venue.find(params[:venue_id])
    respond_to do |format|
      format.html 
      format.js
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue = Venue.find(params[:id])
    
    authorize! :destroy, @venue
    
    @venue.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
    end
  end

  def tags
    scope = ActsAsTaggableOn::Tag.where(["name ILIKE ?", "%#{params[:q]}%"])
    tags = scope.paginate(:page => params[:page], :per_page => params[:limit] || 10)
    render json: { tags: tags, total: scope.count }
  end

  private
  
  def remember_location
    logger.debug("Venues#remember_location - storing location: #{venue_url(:id => params[:venue_id])}")
    session[:venue_path] = venue_url(:id => params[:venue_id])
  end
  
  
end
