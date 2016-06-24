# The Emitter's responsibility is to prepare the message
# representation of events and publish them to RabbitMQ. (That way we
# can keep out representation layer logic from Rails' models.)
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

  def venue_transition(venue, transition)
    emit x: 'venue_transition',
         transition: transition,
         venue: venue.attributes
  end

  def talk_transition(talk, transition)
    emit x: 'talk_transition',
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
           },
           venue: {
             id: talk.venue_id
           }
         }
  end

  def transaction_transition(transaction, transition)
    emit x: 'transaction_transition',
         event: transition, # TODO rename to transition
         details: transaction.message_details
  end

  def dj_callback(callback, opts, job)
    emit x: 'dj_callback',
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
      payload[:talk_url]   = url_helpers.talk_url(resource.talk)
      payload[:talk_title] = resource.talk.title
      payload[:user_url]   = url_helpers.user_url(resource.user)
      payload[:user_name]  = resource.user.name
    when :user
      payload[:user_url] = url_helpers.user_url(resource)
    end

    emit(payload)
  end

  def audio_processing(payload)
    emit payload.merge(x: 'audio_processing')
  end

  def handyman(message)
    emit x: 'notification',
         text: message,
         username: 'Handyman',
         icon_emoji: ':construction_worker:'
  end

  private

  def emit(opts)
    Rails.logger.info("EMIT: #{opts.inspect}")
    publish(opts)
  end

  # make url helpers available on instance level
  def url_helpers
    @helpers ||= Rails.application.routes.url_helpers
  end

end
