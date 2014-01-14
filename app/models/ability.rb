class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, Article do |article|
      article.user == user
    end

    can :manage, Comment, user_id: user.id

    can :manage, User do |usr|
      usr == user
    end
    
    can :manage, Account do |account|
      user.account == account
    end
    
    can :manage, Venue do |venue|
      venue.user == user
    end
    
  end
end
