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
        format.html { redirect_to dashboard_contacts_url, notice: t('controller_follows.follow_created', :default => 'Follow was successfully created.') }
        format.json { render json: @follow, status: :created, location: @follow }
      else
        format.html { render action: "new" }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /follows/1
  # DELETE /follows/1.json
  def destroy
    @follow = Follow.find(params[:id])
    @follow.destroy
    
    authorize! :destroy, @follow

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
