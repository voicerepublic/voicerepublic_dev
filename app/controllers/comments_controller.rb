class CommentsController < ApplicationController
  
  before_filter :set_commentable
  
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
  end

  # POST /comments
  # POST /comments.json
  def create
    logger.debug("Comments#create - current_user: #{current_user.inspect}")
    if params[:status_update_id]
      @comment = StatusUpdate.find(params[:status_update_id]).comments.create(params[:comment].merge(:user_id => current_user.id))
      logger.debug(@comment.inspect)
    else
      redirect_to :back, warn: 'at this time only status-updates can be commented...'
    end
    

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.commentable.user, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment.commentable.user }
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
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to user_status_update_url(:user_id => @comment.commentable.user.id, :status_update_id => @comment.commentable.id) }
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
