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
  
  def  latest_klus
    
  end

  # GET /klus/1
  # GET /klus/1.json
  def show
    @klu = Klu.find(params[:id])
    @user = @klu.user
    @comments = @klu.comments.paginate(:page => params[:page], :per_page => 5, :order => 'created_at DESC')

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
      
      unless @user.balance_account
        logger.info("KlusController#new - redirecting to balance_account_path")
        flash[:warn] = I18n.translate('controller_klus.balance_account_not_created_yet')
        redirect_to user_balance_account_path(:user_id => @user)  and return
      end
   
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
        @klu = @user.kluuus.build(params[:klu].merge(:published => true))
      when 'NoKluuu'
        logger.debug params[:klu][:tag_list]
        if params[:klu][:tag_list] == "newcomer"
          tag_list = params[:klu][:tag_list] + ", " + params[:klu][:title]
          @klu = @user.no_kluuus.build(params[:klu].merge(:published => true).merge(:tag_list => tag_list))
        else
          @klu = @user.no_kluuus.build(params[:klu].merge(:published => true))
        end
      end
    else
      @klu = @user.no_kluuus.build(params[:klu].merge(:published => true))
    end

    respond_to do |format|
      if @klu.save
          format.html do 
            if session[:return_to]
              redirect_to session.delete(:return_to)
            else
              redirect_to user_url(:id => @user), notice: "Your Klu was successfully created!" 
            end
           end
          format.json { render json: @klu, status: :created, location: @klu }
      else
        flash.now[:error] = "An Error occured during save..."
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
    url = @klu.instance_of?(NoKluuu) ? no_kluuus_user_path(:id => _user) : user_path(:id => _user)
    @klu.destroy

    respond_to do |format|
      format.html { redirect_to url }
      format.json { head :no_content }
    end
  end
  
  
end
