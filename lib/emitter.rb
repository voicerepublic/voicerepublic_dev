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
                url: url_helpers.talk_url(talk)
              },
              user: {
                name: talk.user.name,
                url: url_helpers.user_url(talk.user)
              }
            }
  end

  def transaction_transition(transaction, transition)
    publish x: 'transaction_transition',
            event: transition, # TODO rename to transition
            details: transaction.message_details
  end

  def dj_callback(callback, opts, job)
    publish x: 'dj_callback',
            event: callback, # TODO rename to callback
            opts: opts,
            job: job.attributes
  end

  def lifecycle(resource_type, resource, event)
    case resource_type

    when :message
      publish x: 'lifecycle_message',
              event: event,
              message: resource.attributes,
              talk_url: url_helpers.talk_url(resource.talk)

    when :user
      publish x: 'lifecycle_user',
              event: event,
              user: {
                name: resource.name,
                email: resource.email,
                url: url_helpers.user_url(resource)
              }
    end
  end

  private

  # make url helpers available on instance level
  def url_helpers
    @helpers ||= Rails.application.routes.url_helpers
  end

end
