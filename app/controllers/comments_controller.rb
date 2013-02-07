class CommentsController < ApplicationController
  layout 'users'
  
  before_filter :set_commentable
  before_filter :authenticate_user!, :except => [:show, :index]

  # GET /comments
  # GET /comments.json
  def index
    @comments = StatusUpdate.find(params[:status_update_id]).comments #Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new
    if params[:status_update_id]
      @status_update = StatusUpdate.find(params[:status_update_id])
    end
    
    @user = current_user
   
    logger.debug
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    authorize! :edit, @comment
  end

  # POST /comments
  # POST /comments.json
  def create
    
    if params[:status_update_id]
      @comment = StatusUpdate.find(params[:status_update_id]).comments.build(params[:comment].merge(:user_id => current_user.id))
      logger.debug(@comment.inspect)
    end
    if params[:venue_id]
      @comment = Venue.find( params[:venue_id] ).comments.build(params[:comment].merge(:user_id => current_user.id) )
    end
    
    unless @comment
      flash[:alert] = 'type can not be commented ...' 
      redirect_to :back and return
    end
    

    respond_to do |format|
      if @comment.save
        format.html { redirect_to :back }
        #format.html { redirect_to user_status_update_path(:user_id => @comment.commentable.user, :id => @comment.commentable), notice: I18n.t('controller_comments.comment_created', :default => 'Comment was successfully created.') }
        #format.json { render json: @comment, status: :created, location: @comment.commentable.user }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    
    authorize! :update, @comment
    
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to user_status_update_path(:user_id => @comment.commentable.user.id, :status_update_id => @comment.commentable ), notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    
    authorize! :destroy, @comment
    
    @comment.destroy

    respond_to do |format|
      format.html do 
        flash[:notice] = "Comment destroyed"
        redirect_to :back
      end
       #user_status_update_comments_url(:user_id => @comment.commentable.user.id, :status_update_id => @comment.commentable.id) }
      format.json { head :no_content }
    end
  end
  
  private 
  
  def set_commentable
    if params[:status_update_id]
      @commentable = StatusUpdate.find(params[:status_update_id])
    end
  end
end
