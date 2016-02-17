# Events
#
# * enqueued
# * before
# * after
# * success
# * error
# * failure
#
class Mediator
  module DjCallback

    extend self

    TEMPLATES = {
      'success' => {
        'Postprocess'     => 'Postprocessing of Talk %s is complete.',
        'Reprocess'       => 'Reprocessing of Talk %s is complete.',
        'DestroyTalk'     => 'Test Talk %s has been destroyed.',
        'EndTalk'         => 'Talk %s has been ended by the system.',
        'GenerateFlyer'   => 'Flyer for Talk %s has been generated.',
        'ProcessOverride' => 'Override for Talk %s has been processed.',
        'ProcessSlides'   => 'Slides for Talk %s have been processed.'
      }
    }

    def call(*args)
      body = args.first
      event = body['event']

      options = body['opts']
      id = options['id']
      job = body['job']

      handler = job['handler'].match(/struct:([^\n]+)/)[1]

      message = nil
      #message = "Unknown combination event #{event}, handler #{handler}"

      template = TEMPLATES[event][handler]
      message = template % id if template
      return nil unless message

      { x: 'notification', text: message }
    end

  end
end
