# Preview all emails at http://localhost:3000/rails/mailers
#
# This is executed in environment `development`!
#
class CustomDeviseMailerPreview < ActionMailer::Preview

  def confirmation_instructions
    ::CustomDeviseMailer.confirmation_instructions(User.last, 'faketoken', {})
  end

end
