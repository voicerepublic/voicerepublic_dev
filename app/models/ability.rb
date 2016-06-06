# This file is heavily spec'ed in `spec/models/ability_spec.rb`.
#
# Models are given in alphabetical order.
#
class Ability
  include CanCan::Ability

  def initialize(user=nil)

    can    :read, :all
    cannot :read, Purchase
    cannot :read, Venue

    # anonymous does not have any more abilities
    return if user.nil?

    # Appearance is somewhat nested in Talk

    can    :create, Message

    can    :manage, Participation, user_id: user.id

    can    :create, Purchase
    can    :show,   Purchase, owner_id: user.id

    can    :manage, Reminder, user_id: user.id

    can    :manage, Talk, series: { user_id: user.id }
    cannot :create, Talk
    can    :create, Talk, dryrun: true

    # NOTE everything is for free ATM
    #if user.credits > 0
    can    :create, Talk, series: { user_id: user.id }
    # this is covered by default_series, but it should probably go into
    # the controller before the authorization
    can    :create, Talk, series_id: nil
    #end

    can    :manage, User, id: user.id

    can    :manage, Series, user_id: user.id

    can    :manage, Venue, user_id: user.id
  end
end
