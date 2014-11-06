# The MessageCenter is as the name suggests a central hub for messages.
#
# Message can be emitted from every part of the application, the
# MessageCenter's responsibility is to distribute these message into
# its outlets.

class MessageCenter

  include Singleton

  def method_missing(method, *args)
    return instance.send(method, *args) if instance.respond_to?(method)
    super
  end

  def talk_event(talk, *args)
    current_state, new_state, event = args

    PrivatePub.publish_to '/event/talk', { talk: talk.attributes, args: args }

    @slack ||= Slack.new("#vr_sys_#{Settings.slack.tag}", 'transitions',
                         Settings.slack.icon[:transitions])

    msg = case event
          when :start_talk
            "NOW LIVE (#{talk.id}) <#{talk.title}|#{uh.talk_url(talk)}>" +
              " in <#{talk.venue.title}|#{uh.venue_url(talk.venue)}>" +
              " by <#{talk.venue.user.name}|#{uh.user_url(talk.venue.user)}>"
          when :archived
            "JUST ARCHIVED (#{talk.id}) <#{talk.title}|#{uh.talk_url(talk)}>" +
              " in <#{talk.venue.title}|#{uh.venue_url(talk.venue)}>" +
              " by <#{talk.venue.user.name}|#{uh.user_url(talk.venue.user)}>"
          else
            "Don't know how to format talk event `#{event}` for talk #{talk.id}"
          end

    @slack.send msg
  end

  private

  def uh
    Rails.application.routes.url_helpers
  end

end
