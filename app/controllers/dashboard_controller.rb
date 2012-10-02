class DashboardController < ApplicationController

  before_filter :authenticate_user!
  before_filter :set_user
  def index
    @user = current_user
    redirect_to :action => 'matches'
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
    @klus = @user.klus
    begin
      if params[:id]
        @matched_klu = Klu.find(params[:id])
        @matching_klus = @matched_klu.complementaries
      else
        unless @klus.empty?
          @matched_klu = @klus.first
          @matching_klus = @matched_klu.complementaries
        end
      end
    rescue Exception => e
      logger.error("Dasboard#matches - problem with sphinx: #{e.inspect}")
      @matching_klus = []
    end
    flash.now.error "there is a problem with sphinx"

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
