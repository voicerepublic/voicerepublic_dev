class KlusController < ApplicationController
  # GET /klus
  # GET /klus.json
  def index
    @klus = Klu.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @klus }
    end
  end

  # GET /klus/1
  # GET /klus/1.json
  def show
    @klu = Klu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @klu }
    end
  end

  # GET /klus/new
  # GET /klus/new.json
  def new
    @user = User.find(params[:user_id])
    @klu = Klu.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @klu }
    end
  end

  # GET /klus/1/edit
  def edit
    @klu = Klu.find(params[:id])
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
        @klu = @user.no_kluus.build(params[:klu])
      end
    else
      @klu = @user.no_kluuus.build(params[:klu])
    end

    respond_to do |format|
      if @klu.save
        format.html { redirect_to user_klus_url(:user_id => @user), notice: 'Klu was successfully created.' }
        format.json { render json: @klu, status: :created, location: @klu }
      else
        format.html { render action: "new" }
        format.json { render json: @klu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /klus/1
  # PUT /klus/1.json
  def update
    @klu = Klu.find(params[:id])

    respond_to do |format|
      if @klu.update_attributes(params[:klu])
        format.html { redirect_to user_klu_path(:user_id => @klu.user, :id => @klu), notice: 'Klu was successfully updated.' }
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
    _user = @klu.user
    @klu.destroy

    respond_to do |format|
      format.html { redirect_to user_klus_url(:user_id => _user) }
      format.json { head :no_content }
    end
  end
end
