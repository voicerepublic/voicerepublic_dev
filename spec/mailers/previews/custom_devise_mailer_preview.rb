# Preview all emails at http://localhost:3000/rails/mailers
#
# This is executed in environment `development`!
#
class CustomDeviseMailerPreview < ActionMailer::Preview

  def confirmation_instructions
    ::CustomDeviseMailer.confirmation_instructions(User.last, 'faketoken', {})
  end

  def reset_password_instructions
    ::CustomDeviseMailer.reset_password_instructions(User.last, 'faketoken', {})
  end

  # We don't use that feature
  #def unlock_instructions
  #  ::CustomDeviseMailer.unlock_instructions(User.last, 'faketoken', {})
  #end

  # We have to upgrade devise to use that feature
  #def password_change
  #  ::CustomDeviseMailer.password_change(User.last, {})
  #end

end
