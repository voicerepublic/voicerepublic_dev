class KluImagesController < ApplicationController
  
  before_filter :set_kluuu
  # GET /klu_images
  # GET /klu_images.json
  def index
    @klu_images = @kluuu.klu_images

      respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @klu_images }
    end
  end

  # GET /klu_images/1
  # GET /klu_images/1.json
  def show
    @klu_image = KluImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @klu_image }
    end
  end

  # GET /klu_images/new
  # GET /klu_images/new.json
  def new
    @klu_image = @kluuu.klu_images.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @klu_image }
    end
  end

  # GET /klu_images/1/edit
  def edit
    @klu_image = KluImage.find(params[:id])
  end

  # POST /klu_images
  # POST /klu_images.json
  def create
    @klu_image = KluImage.new(params[:klu_image].merge(:klu_id => @kluuu.id))
    
    respond_to do |format|
      if @klu_image.save
        format.html { redirect_to user_klu_path(:user_id => params[:user_id], :id => @kluuu), notice: 'Klu image was successfully created.' }
        format.json { render json: @klu_image, status: :created, location: @klu_image }
      else
        logger.error("KluImages#create - error: \n#{@klu_image.errors.inspect}\n")
        format.html { render action: "new" }
        format.json { render json: @klu_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /klu_images/1
  # PUT /klu_images/1.json
  def update
    @klu_image = KluImage.find(params[:id])

    respond_to do |format|
      if @klu_image.update_attributes(params[:klu_image])
        format.html { redirect_to user_klu_klu_image_path(:user_id => @klu_image.kluuu.user, :klu_id => @klu_image.kluuu, :id => @klu_image), notice: 'Klu image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @klu_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /klu_images/1
  # DELETE /klu_images/1.json
  def destroy
    @klu_image = KluImage.find(params[:id])
    @kluuu = @klu_image.kluuu
    @klu_image.destroy

    respond_to do |format|
      format.html { redirect_to user_klu_klu_images_url(:user_id => @kluuu.user, :klu_id => @kluuu) }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_kluuu
    @kluuu = Kluuu.find(params[:klu_id])    
  end
end
