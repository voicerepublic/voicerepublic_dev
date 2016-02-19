# The Emitter's responsibility is to prepare the message
# representation of events and publish them to RabbitMQ. (That way we
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
                url: url_helpers.talk_url(talk),
                error: talk.processing_error
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
    payload = {
      x: "lifecycle_#{resource_type}",
      event: event,
      attributes: resource.attributes
    }

    # add event specific details
    payload[:changes] = resource.changes if event == :update

    # add type specific details
    case resource_type
    when :message
      payload[:talk_url] = url_helpers.talk_url(resource.talk)
    when :user
      payload[:user_url] = url_helpers.user_url(resource)
    end

    publish(payload)
  end

  def audio_processing(payload)
    publish payload.merge(x: 'audio_processing')
  end

  private

  # make url helpers available on instance level
  def url_helpers
    @helpers ||= Rails.application.routes.url_helpers
  end

end
