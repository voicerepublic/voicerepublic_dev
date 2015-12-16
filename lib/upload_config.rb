class UploadConfig < Struct.new(:talk, :user)

  def to_json
    return JSON.pretty_generate(to_hash) if Rails.env.development?
    to_hash.to_json
  end

  def to_hash
    {
      # user
      user: user_details,
      # faye
      fayeClientUrl: Settings.faye.server + '/client.js',
      fayeUrl: Settings.faye.server,
      subscriptions: [ '/audit' ],
      flags: {}
    }.tap do |hash|
      hash[:user][:upmsg] = '/audit'
    end
  end

  def user_details
    return @user_details ||= user.details_for(talk) if user
    { role: :listener }
  end

end
