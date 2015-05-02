# Preview all emails at http://localhost:3000/rails/mailers/plain_mailer
#
# This is executed in environment `development`!
#
class PlainMailerPreview < ActionMailer::Preview

  def welcome
    PlainMailer.welcome(User.last)
  end

end
