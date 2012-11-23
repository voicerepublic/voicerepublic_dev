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
      format.html 
      format.json { render json: @follows }
    end
  end

  def bookmarks
    @bookmarks = @user.bookmarks
    respond_to do |format|
      format.html 
      format.json { render json: @bookmarks }
    end
  end

  def news
    ret = @user.notifications.call_alerts.destroy_all
    logger.debug("Dashboard#news - destroying all call_alerts - count deleted: #{ret.length}")
    @news = @user.notifications.news_alerts.order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
    #@news.each { |x| Notification::Base.find(x.id).update_attribute(:read, true) }
    logger.debug("Dashboard#news - updating attribute 'read' to true")
    @news.each { |x| x.update_attribute(:read, true) }
    respond_to do |format|
      format.html 
      format.json { render json: @news }
    end
  end
  
  def delete_notification
    n = Notification::Base.find(params[:notification_id])
    @css_id = "notification-#{params[:notification_id]}"
    
    authorize! :destroy, n
    
    if n.destroy
      flash.now[:notice] = t('controller_dashboard.notification_destroyed', :default => 'destroyed notification')
    else
      flash.now[:error] = t('was not able to delete notification')
    end
    respond_to do |format|
      format.html { redirect_to dashboard_url }
      format.js 
    end
  end

  def matches
    @klus = @user.kluuus.order("created_at DESC")
    @no_klus = @user.no_kluuus.order("created_at DESC")
    
    begin
      if params[:id]
        @matched_klu = Klu.find(params[:id])
        @matching_klus = @matched_klu.complementaries
      else
        unless @klus.empty? &&  @no_klus.empty?
          _klu = @klus.first || @no_klus.first
          redirect_to dashboard_matches_url(:id => _klu) and return
          #@matched_klu = @klus.first
          #@matching_klus = @matched_klu.complementaries
        end
      end
    rescue Exception => e
      logger.error("Dasboard#matches - problem with sphinx: #{e.inspect}")
      @matching_klus = []
      flash.now[:error] =  "there is a problem with sphinx... stay calm"
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @matches }
    end
  end
  
  def settings
    @account = @user.account
  end
  
  def edit_settings
    @account = @user.account
  end
  
  def edit_password
    @user
  end
  

  private

  def set_user
    @user = current_user
  end
end
