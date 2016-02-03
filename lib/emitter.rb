# The Emitter's responsibility is to prepare the message
# representation of events nd publish them to RabbitMQ. (That way we
# can keep out representation layer logic from Rails' models.
#
# All methods are statically available, so you can simply
# call them like this, e.g.
#
#     Emitter.talk_transition(some_talk, some_transition)
#
module Emitter

  # make url helpers available on instance level
  include Rails.application.routes.url_helpers

  include Services::Publisher

  # make all methods statically available
  extend self

  def talk_transition(talk, transition)
    publish x: 'talk_transition',
            details: { # TODO lose nesting in details
              event: transition, # TODO rename to transition
              talk: {
                id: talk.id,
                title: talk.title,
                url: talk_url(talk)
              },
              user: {
                name: talk.user.name,
                url: user_url(talk.user)
              }
            }
  end

  def user_registration(user)
    publish x: 'user_registration',
            user: {
              name: user.name,
              email: user.email
            }
  end

  def transaction_transition(transaction, transition)
    publish x: 'transaction_transition',
            event: transition, # TODO rename to transition
            details: transaction.message_details
  end

  def dj_callback(callback, opts, job)
    publish x: 'dj_callback',
            event: 'callback', # TODO rename to callback
            opts: opts,
            job: job.attributes
  end

end
