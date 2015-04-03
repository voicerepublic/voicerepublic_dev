# this is heavily spec'ed in spec/models/ability_spec.rb
#
class Ability
  include CanCan::Ability

  def initialize(user=User.new)

    can    :manage, User, id: user.id

    can    :manage, Venue, user_id: user.id

    can    :manage, Comment, user_id: user.id

    can    :manage, Reminder, user_id: user.id
    cannot :create, Reminder if user.new_record?

    can    :manage, Talk, venue: { user_id: user.id }
    cannot :create, Talk
    can    :create, Talk if user.credits > 0

    can    :create, Purchase if user.persisted?
    can    :read,   Purchase, owner_id: user.id

    can    :create, Message if user.persisted?

  end
end
