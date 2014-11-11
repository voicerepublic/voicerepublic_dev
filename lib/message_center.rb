# The MessageCenter is as the name suggests a central hub for messages.
#
# Message can be emitted from every part of the application, the
# MessageCenter's responsibility is to distribute these message into
# its outlets.
#
# General messages should be swallowed if we are in an environment
# other than 'production'. (Nobody cares about messages from 'dev'
# machines and specs do less rely on VCR.)
#
class MessageCenter

  include Singleton
  include Rails.application.routes.url_helpers


  def talk_event(talk, *args)
    # swallow this message unless we're in production
    return unless Rails.env.production?

    current_state, new_state, event = args

    PrivatePub.publish_to '/event/talk', { talk: talk.attributes, args: args }

    msg = case event
          when :start_talk
            "NOW LIVE (#{talk.id}) <#{talk.title}|#{talk_url(talk)}>" +
              " in <#{talk.venue.title}|#{venue_url(talk.venue)}>" +
              " by <#{talk.venue.user.name}|#{user_url(talk.venue.user)}>"
          when :archived
            "JUST ARCHIVED (#{talk.id}) <#{talk.title}|#{talk_url(talk)}>" +
              " in <#{talk.venue.title}|#{venue_url(talk.venue)}>" +
              " by <#{talk.venue.user.name}|#{user_url(talk.venue.user)}>"
          else
            "Don't know how to format talk event `#{event}` for talk #{talk.id}"
          end

    slack.send msg
  end

  def kill_talk(talk)
    slack.send "killed talk (#{talk.id}) <#{url_for(talk)}|#{talk.title}>",
               user: "dj-trigger", icon: Settings.slack.icon[:trigger]
  end

  private

  def slack
    Slack.new("#vr_sys_#{Settings.slack.tag}", 'transitions',
              Settings.slack.icon[:transitions])
  end

  # delegates all class method calls to its singleton instance
  def method_missing(method, *args)
    return instance.send(method, *args) if instance.respond_to?(method)
    super
  end

end
