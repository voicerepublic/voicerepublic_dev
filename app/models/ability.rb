# this is heavily spec'ed in spec/models/ability_spec.rb
#
class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    return if user.guest?
    
    can :manage, User,    id: user.id
    can :manage, Venue,   user_id: user.id
    can :manage, Comment, user_id: user.id

    can :manage, Talk do |talk|
      talk.venue.user_id == user.id
    end
    
    can :create, Venue do |venue|
      !user.guest?
    end
    
  end
end
