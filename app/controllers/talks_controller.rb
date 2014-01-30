class TalksController < ApplicationController

  before_action :set_venue
  before_action :set_talk, only: [:show, :edit, :update, :destroy]

  # GET /talks
  def index
    @talks = Talk.all
  end

  # GET /talks/1
  def show
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
    params.require(:talk).permit(:title, :teaser,
                                 :starts_at, :duration,
                                 :description, :record)
  end

end
