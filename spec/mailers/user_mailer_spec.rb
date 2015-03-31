require "rails_helper"

describe UserMailer do

  let(:user) { FactoryGirl.create(:user) }

  it 'sends emails on new talk' do
    talk = FactoryGirl.create(:talk)
    email = UserMailer.new_talk(talk, user).deliver_now
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email.to_s).to_not include('translation missing')
    expect(email.to_s).to include(user.firstname)
    expect(email.to_s).to include('flyer.png')
  end

  it 'sends emails on reminder' do
    talk = FactoryGirl.create(:talk)
    email = UserMailer.reminder(talk, user).deliver_now
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email.to_s).to_not include('translation missing')
    expect(email.to_s).to include(user.firstname)
    expect(email.to_s).to include('flyer.png')
  end

  it 'sends emails on new comment' do
    comment = FactoryGirl.create(:comment)
    email = UserMailer.new_comment(comment, user).deliver_now
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email.to_s).to_not include('translation missing')
    expect(email.to_s).to include(user.firstname)
  end

end
