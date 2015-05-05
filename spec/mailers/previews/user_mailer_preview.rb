# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
#
# This is executed in environment `development`!
#
class UserMailerPreview < ActionMailer::Preview

  def new_talk
    UserMailer.new_talk(Talk.last, User.last)
  end

  def reminder
    UserMailer.reminder(Talk.last, User.last)
  end

  def welcome
    UserMailer.welcome(User.last)
  end

  def new_comment
    UserMailer.new_comment(Comment.last, User.last)
  end

end
