module VideoSessionsHelper
  def build_video_session(user = nil)
    if user.nil?
      return VideoSession::Anonymous.new
    else
      return VideoSession::Registered.new
    end
  end
end
