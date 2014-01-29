class ArticlesController < ApplicationController

  layout 'users'
  
  before_filter :set_venue
  before_filter :authenticate_user!, :except => [:show, :index]

  # GET /articles
  # GET /articles.json
  def index
    @articles = StatusUpdate.find(params[:status_update_id]).articles #Article.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new
    if params[:status_update_id]
      @status_update = StatusUpdate.find(params[:status_update_id])
    end
    
    @user = current_or_guest_user
   
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
    authorize! :edit, @article
  end

  def create
    @article = @venue.articles.build(params[:article])
    @article.user_id = current_or_guest_user.id

    logger.debug(@article.inspect)
    
    unless @article
      flash[:alert] = 'type can not be articled ...' 
      redirect_to :back and return
    end

    respond_to do |format|
      if @article.save
        send_email(@article)
        format.html { redirect_to :back }
      else
        format.html { render action: "new" } # this is wrong
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])
    
    authorize! :update, @article
    
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to user_status_update_path(:user_id => @article.venue.user.id, :status_update_id => @article.venue ), notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    
    authorize! :destroy, @article
    
    @article.destroy

    respond_to do |format|
      format.html do 
        flash[:notice] = "Article destroyed"
        redirect_to :back
      end
       #user_status_update_articles_url(:user_id => @comment.venue.user.id, :status_update_id => @comment.venue.id) }
      format.json { head :no_content }
    end
  end
  
  private 
  
  def set_venue
    @venue = Venue.find(params[:venue_id])
  end

  def send_email(article)
    users = article.venue.attendees
    (users - [current_or_guest_user]).each do |user|
      UserMailer.delay(queue: 'mail').new_article_notification(article, user)
    end
  end

end
