class VenuesController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index]
  
  # GET /venues
  # GET /venues.json
  def index
    @venues = Venue.where("start_time > ?", Time.now - 1.hour).order("start_time ASC").paginate(:page => params[:page], :per_page => 5)

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
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(params[:venue])
    
    authorize! :create, @venue

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        format.json { render json: @venue, status: :created, location: @venue }
      else
        format.html { render action: "new" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
    @venue = Venue.find(params[:id])

    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # POST /venues/1/join_venue/5
  #
  def join_venue
    @venue = Venue.find(params[:venue_id])
    klu = Klu.find(params[:klu_id])
    
    venue_klu = VenueKlu.new(:venue => @venue, :klu => klu )
    
    authorize! :create, venue_klu
    
    respond_to do |format|
      if venue_klu.save
        format.html { redirect_to @venue, notice: "Successfully joined venue" }
        format.json { head :no_content }
      else
        format.html { redirect_to @venue, alert: "Wasn't not able to join venue - perhaps already subscribed?" }
        format.json { head :no_content }
      end
    end
  end
  
  def unjoin_venue
    @venue = Venue.find(params[:venue_id])
    @venue.venue_klus.collect { |vk| vk.destroy if vk.klu.user == current_user }
    
    respond_to do |format|
      format.html { redirect_to @venue, notice: "Successfully unjoined venue" }
      #format.js {}
    end
  end
  
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
    @venue.destroy

    respond_to do |format|
      format.html { redirect_to venues_url }
      format.json { head :no_content }
    end
  end
end
