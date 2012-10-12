class RatingsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :set_klu
  
  # GET /ratings/new
  # GET /ratings/new.json
  def new
    @rating = @klu.ratings.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rating }
    end
  end

  # POST /ratings
  # POST /ratings.json
  def create
    @rating = @klu.ratings.build(params[:rating].merge(:user_id => current_user.id))
    
    logger.debug("Ratings#create - initialized rating before save: #{@rating.inspect}")
 
    respond_to do |format|
      if @rating.save
        format.html { redirect_to klu_path(:id =>  @klu), notice: 'Rating was successfully created.' }
        format.json { render json: @rating, status: :created, location: @rating }
      else
        format.html { render action: "new" }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def set_klu
    @klu = Klu.find(params[:klu_id]) || nil
  end
end
