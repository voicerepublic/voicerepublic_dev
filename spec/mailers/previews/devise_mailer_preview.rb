# Preview all emails at http://localhost:3000/rails/mailers/plain_mailer
#
# This is executed in environment `development`!
#
class DeviseMailerPreview < ActionMailer::Preview

  def confirmations_instructions
    Devise::Mailer.confirmation_instructions(User.last, 'asdf-token')
  end

end
