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
  module TalkTransition

    # TODO if job is end_talk and event/callback is success -> 'Forced to end Talk...'


    extend self

    TEMPLATES = {
      'created.prelive.prepare'      => 'Has been created',
      'prelive.live.start_talk'      => 'Now live',
      'live.postlive.end_talk'       => 'Has come to end',
      'postlive.processing.process'  => 'Started processing',
      'processing.archived.archive'  => 'Just archived recording',
      'pending.archived.archive'     => 'Just archived upload',
      'processing.suspended.suspend' => 'Failed to process'
    }

    def call(*args)
      body = args.first
      event = body['details']['event'] * '.'
      template = TEMPLATES[event]
      template ||= 'Don\'t know how to format talk event `%s` for' % event
      talk = body['details']['talk']
      user = body['details']['user']
      _talk = slack_link(talk['title'], talk['url'])
      _user = slack_link(user['name'], user['url'])

      { x: 'notification', text: "#{intro} (#{talk['id']}) #{_talk} by #{_user}" }
    end

    private

    def slack_link(title, url)
      "<#{url}|#{title}>"
    end

  end
end
