class DashboardController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :set_user
  
  def index
    @user = current_user
  end
  
  def contacts
    @followed = @user.followed_relations
    @follower = @user.follower_relations

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @follows }
    end
  end
  
  def bookmarks
    @bookmarks = @user.bookmarks
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookmarks }
    end
  end
  
  def news
    @news = nil
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @news }
    end
  end
  
  
  def matches 
    @user.klus
    @matches = nil
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @matches }
    end
  end
  
  private
  
  def set_user
    @user = current_user
  end
end
