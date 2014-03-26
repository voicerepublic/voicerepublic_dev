require "spec_helper"

describe UserMailer do

  let(:user) { FactoryGirl.create(:user) }

  it 'sends emails on new talk' do
    talk = FactoryGirl.create(:talk)
    email = UserMailer.new_talk(talk, user).deliver
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email.to_s).to_not include('translation missing')
    expect(email.to_s).to include(user.firstname)
  end

  it 'sends emails on reminder' do
    talk = FactoryGirl.create(:talk)
    email = UserMailer.reminder(talk, user).deliver
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email.to_s).to_not include('translation missing')
    expect(email.to_s).to include(user.firstname)
  end

  it 'sends emails on new comment' do
    comment = FactoryGirl.create(:comment)
    email = UserMailer.new_comment(comment, user).deliver
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email.to_s).to_not include('translation missing')
    expect(email.to_s).to include(user.firstname)
  end

end
