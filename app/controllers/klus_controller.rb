class KlusController < ApplicationController
  #layout 'users', :except =>  [:index]
  # GET /klus
  # GET /klus.json
  def index
    @user = User.find(params[:user_id])
    @kluuus = @user.kluuus
    @no_kluuus = @user.no_kluuus
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @klus }
    end
  end

  # GET /klus/1
  # GET /klus/1.json
  def show
    @klu = Klu.find(params[:id])
    @user = @klu.user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @klu }
    end
  end

  # GET /klus/new
  # GET /klus/new.json
  def new
    @user = User.find(params[:user_id])
    logger.debug("Klus#new - params: #{params.inspect} - '#{params[:klu_type]}'")
    if params[:klu_type] && ( params[:klu_type] == 'Kluuu' )
      logger.debug("Klus#new - in params scope - creating new Kluuu")
      @klu = Kluuu.new(:published => true)
      @klu.klu_images.build
    else
      logger.debug("Klus#new  - creating new NoKluuu")
      @klu = NoKluuu.new(:published => true)
      if params[:query]
        @klu.title = params[:query]
        @klu.tag_list = params[:query].split(' ')
      end
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @klu }
    end
  end

  # GET /klus/1/edit
  def edit
    @klu = Klu.find(params[:id])
    @user = @klu.user
  end

  # POST /klus
  # POST /klus.json
  def create
    @user = User.find(params[:user_id]) 
    if params[:klu_type]
      case params[:klu_type]
      when 'Kluuu'
        @klu = @user.kluuus.build(params[:klu])
      when 'NoKluuu'
        @klu = @user.no_kluuus.build(params[:klu])
      end
    else
      @klu = @user.no_kluuus.build(params[:klu])
    end

    respond_to do |format|
      if @klu.save
        format.html { redirect_to user_url(:id => @user), notice: 'Klu was successfully created.' }
        format.json { render json: @klu, status: :created, location: @klu }
      else
        flash.now[:error] = @klu.errors.inspect
        format.html { render action: "new" }
        format.json { render json: @klu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /klus/1
  # PUT /klus/1.json
  def update
    logger.debug("Klus#update - params: #{params.inspect}")
    @klu = Klu.find(params[:id])
    @user = @klu.user
    
    authorize! :update, @klu

    respond_to do |format|
      if @klu.update_attributes(params[:klu])
        format.html { redirect_to user_klu_path(:user_id => @user, :id => @klu), notice: 'Klu was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @klu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /klus/1
  # DELETE /klus/1.json
  def destroy
    @klu = Klu.find(params[:id])
    
    authorize! :destroy, @klu
    
    _user = @klu.user
    @klu.destroy

    respond_to do |format|
      format.html { redirect_to user_url(:id => _user) }
      format.json { head :no_content }
    end
  end
  
  
end
