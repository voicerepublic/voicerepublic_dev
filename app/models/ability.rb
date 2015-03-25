# this is heavily spec'ed in spec/models/ability_spec.rb
#
class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    return false if user.guest?

    can :manage, User,    id: user.id
    can :manage, Venue,   user_id: user.id
    can :manage, Comment, user_id: user.id
    can :create, Reminder unless user.guest?
    can :manage, Reminder, user_id: user.id


    can :manage, Talk do |talk|
      talk.venue.nil? or # TODO check if needed
        talk.venue.user_id == user.id
    end


  end
end
