# This file is heavily spec'ed in `spec/models/ability_spec.rb`.
#
# Models are given in alphabetical order.
#
class Ability
  include CanCan::Ability

  def initialize(user=nil)

    user ||= User.new

    # Appearance is somewhat nested in Talk

    # Comment is currently not in use
    can    :manage, Comment, user_id: user.id

    can    :create, Message if user.persisted?

    # Participation is not in use

    can    :create, Purchase if user.persisted?
    can    :read,   Purchase, owner_id: user.id

    can    :manage, Reminder, user_id: user.id
    cannot :create, Reminder if user.new_record?

    can    :manage, Talk, venue: { user_id: user.id }
    cannot :create, Talk
    can    :create, Talk, venue: { user_id: user.id } if user.credits > 0
    # this is covered by default_venue, but it should probably go into
    # the controller before the authorization
    can    :create, Talk, venue_id: nil if user.credits > 0

    can    :manage, User, id: user.id

    can    :manage, Venue, user_id: user.id

  end
end
