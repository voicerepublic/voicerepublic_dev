class Participant::Anonymous < Participant::Base
  attr_accessible :user_cookie_session_id
  validates_presence_of :user_cookie_session_id
end
