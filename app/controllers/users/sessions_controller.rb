class Users::SessionsController < Devise::SessionsController
  
  def create
    logger.debug("Users::SessionsController#create - log in user...")
    if current_user.klus.empty?
      @user = current_user
      @klu = NoKluuu.new(:user_id => current_user.id, :tag_list => "kluuu, fun, newcomer, neuling, talk")
      render(:action => :welcome) and return
    end
    super
  end

  def destroy
    logger.debug("Users::SessionsController#destroy - log out user...")
    super
  end
  
  def welcome
    
  end
  
end
