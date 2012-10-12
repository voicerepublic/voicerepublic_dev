class FollowsController < ApplicationController
  #layout 'users'
  before_filter :authenticate_user! #, :only => [:create, :destroy, :index]
  before_filter :set_user
  
  # GET /follows
  # GET /follows.json
  def index
    @followed = @user.followed_relations
    @follower = @user.follower_relations

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @follows }
    end
  end

  # GET /follows/1
  # GET /follows/1.json
  def show
    @follow = Follow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @follow }
    end
  end

  # GET /follows/new
  # GET /follows/new.json
  def new
    @follow = Follow.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @follow }
    end
  end

  # GET /follows/1/edit
  def edit
    @follow = Follow.find(params[:id])
  end

  # POST /follows
  # POST /follows.json
  def create
    logger.debug("Follows#create - params: #{params}")
    
    _followed_id = params[:followed_id]
    _user = User.find(params[:followed_id])
    @follow = Follow.new(:followed_id => _user.id, :follower_id => @user.id)
    logger.debug("Follows#create - follow: #{@follow.inspect}")
    respond_to do |format|
      if @follow.save
        format.html { redirect_to dashboard_contacts_url, notice: 'Follow was successfully created.' }
        format.json { render json: @follow, status: :created, location: @follow }
      else
        format.html { render action: "new" }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /follows/1
  # PUT /follows/1.json
  def update
    @follow = Follow.find(params[:id])

    respond_to do |format|
      if @follow.update_attributes(params[:follow])
        format.html { redirect_to @follow, notice: 'Follow was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follows/1
  # DELETE /follows/1.json
  def destroy
    @follow = Follow.find(params[:id])
    @follow.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_contacts_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:user_id])
  end
end
