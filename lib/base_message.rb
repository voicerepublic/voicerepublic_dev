# BaseMessage
# ===========
#
# BaseMessage is the superclass for all Messages defined in the folder
# `app/messages` which is the central location for all message related
# code.
#
# Messages can be emitted from every part of the application, the
# Message's responsibility is to distribute these message into
# its outlets. BaseMessage provides common code for this task.
#
#
# Sidenote on Environments
# ------------------------
#
# There two types of messages:
#
# * mandatory (technically required)
# * optional (fyi only)
#
# General optional messages should be swallowed if we are in an
# environment other than 'production'. (Nobody cares about those
# messages from 'dev' machines and specs do less rely on VCR.)
#
class BaseMessage

  include Singleton

  # make url helpers available on instance level
  include Rails.application.routes.url_helpers

  class << self
    def call(*args)
      instance.distribute(*args) if instance.condition
    end
  end

  def distribute(*args)
    raise "`#{self.class.name}#distribute` not yet implemented"
  end

  def condition
    Rails.env.production?
  end

  private

  def slack_link(title, url)
    "<#{url}|#{title}>"
  end

  def slack #.send message, opts
    @slack ||= Slack.new("#vr_sys_#{Settings.slack.tag}",
                         'transitions',
                         Settings.slack.icon[:transitions])
  end

  def faye #.publish_to channel, message
    Faye
  end

end
