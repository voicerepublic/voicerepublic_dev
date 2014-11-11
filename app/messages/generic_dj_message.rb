# OPTIONAL: goes to slack (in production)
#
class GenericDjMessage < BaseMessage

  def distribute(*args)
    slack.send(*args)
  end

end
