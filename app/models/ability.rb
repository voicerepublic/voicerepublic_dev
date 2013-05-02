class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
      can :manage, :all
    end
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    
    
    
    can :manage, Kluuu do |klu|
      klu.user == user
    end

    can :manage, NoKluuu do |klu|
      klu.user == user
    end
    
    can :rate, Kluuu do |klu|
      n = Notification::MakeRate.where("user_id = ? AND klu_id = ?", user.id,klu.id)
      n.empty? ? false : true
    end
    
    can :manage, KluImage do |ki|
      user == ki.kluuu.user
    end
    
    can :manage, User do |usr|
      usr == user
    end
    
    can :manage, Account do |account|
      user.account == account
    end
    
    can :manage, Notification::Base do |notification|
      user == notification.user
    end
    
    can :manage, StatusUpdate do |su|
      user == su.user
    end
    
    can :manage, Message do |message|
      user == message.sender || message.receiver 
    end
    
    can :manage, Conversation do |conversation|
      user == conversation.user_1 || conversation.user_2
    end
    
    can :manage, Category do |category|
      user.is_admin?
    end
    
    can :manage, Comment do |comment|
      t = false
      if comment.commentable.kind_of?(Venue)
         if comment.commentable.host_kluuu.user == user  || comment.user == user 
           t = true
         end
      end
      if comment.commentable.kind_of?(StatusUpdate)  || comment.commentable.kind_of?(Klu)
        if comment.commentable.user == user || comment.user == user 
          t = true
        end
      end
      
      t
    end
    
    can :manage, Follow do |f|
      f.follower == user
    end
    
    can :manage, Balance::Account do  |ba|
      ba.user == user
    end
    
    can :manage, Bookmark do |bookmark|
      user == bookmark.user
    end
    
    can :manage, Venue do |venue|
      venue.host_kluuu.user == user
    end
    
    #can :create, Venue do |venue|
    #  user.roles.include?(Role.find_by_name('venue_host'))
    #end
    
    can :manage, VenueKlu do |vk|
      vk.klu.user == user 
    end
    
  end
end
