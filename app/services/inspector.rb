require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

# The Inspector should only be used in development.
class Inspector

  include Services::Subscriber

  subscribe handler: :handler, x: 'dj_callback'
  subscribe handler: :handler, x: 'talk_transition'
  subscribe handler: :handler, x: 'lifecycle_user'
  subscribe handler: :handler, x: 'lifecycle_message'
  subscribe handler: :handler, x: 'transaction_transition'
  subscribe handler: :handler, x: 'notification'

  def handler(*args)
    body, _, info, _ = *args
    puts '-' * 80
    puts 'x: '+info[:exchange]
    puts body.to_yaml
  end

end
