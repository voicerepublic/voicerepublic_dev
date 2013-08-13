class ParticipationsController < ApplicationController

  before_filter :store_location
  before_filter :authenticate_user!

  # This is somewhat f*ckd! Devise might redirect here if a currently
  # not signed in user clicks on a participate now button. For now
  # we'll simpy redirect to the venue.
  #
  # GET /participations
  # GET /participations.json
  def index
    redirect_to venue_path(:id => params[:participation][:venue_id]), :notice => 'hey.'

    # @participations = Participation.all
    # 
    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @participations }
    # end
  end
  
  # # GET /participations/1
  # # GET /participations/1.json
  # def show
  #   @participation = Participation.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @participation }
  #   end
  # end
  # 
  # # GET /participations/new
  # # GET /participations/new.json
  # def new
  #   @participation = Participation.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @participation }
  #   end
  # end
  # 
  # # GET /participations/1/edit
  # def edit
  #   @participation = Participation.find(params[:id])
  # end

  # POST /participations
  # POST /participations.json
  def create
    @participation = Participation.new(params[:participation])
    @participation.user_id = current_user.id

    respond_to do |format|
      if @participation.save
        format.html { redirect_to @participation.venue }
        format.json { render json: @participation, status: :created, location: @participation }
      else
        format.html { render action: "new" }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PUT /participations/1
  # # PUT /participations/1.json
  # def update
  #   @participation = Participation.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @participation.update_attributes(params[:participation])
  #       format.html { redirect_to @participation, notice: 'Participation was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @participation.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /participations/1
  # DELETE /participations/1.json
  def destroy
    @participation = Participation.find(params[:id])
    @participation.destroy

    respond_to do |format|
      format.html { redirect_to participations_url }
      format.json { head :no_content }
    end
  end
end
