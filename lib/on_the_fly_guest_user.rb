module OnTheFlyGuestUser

  class User < ActiveRecord::Base
    def send_confirmation_notification?
      false
    end
  end

  # hack to authenticate guest users as well
  def authenticate_user!
    id = session[:guest_user_id]
    if id && @guest_user = User.find(id)
      logger.info "\033[32mAuthenticated guest #{id}\033[0m"
      return @guest_user
    end
    #session[:guest_user_id] = nil
    super
  end

  def current_user
    return @guest_user if @guest_user

    if user = super
      session[:guest_user_id] = nil
      return user
    end
    return nil unless generate_guest_user?
    @guest_user ||= create_guest_user
  end

  private

  def create_guest_user
    token = SecureRandom.uuid
    name = ['guest', token ] * '_'
    logger.debug "\033[31mCREATE GUEST USER: #{name}\033[0m"
    user = User.create( email: "#{name}@example.com",
                        firstname: 'guest',
                        lastname: name,
                        guest: true )
    user.save! validate: false
    session[:guest_user_id] = user.id
    user
  end

  def generate_guest_user?
    true
  end

end

