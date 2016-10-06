require "rails_helper"

describe PlainMailer do
  include DjHelpers

  it 'sends emails on creation of a user with a delay' do
    Delayed::Worker.delay_jobs = true
    Timecop.freeze(Time.local(2036))

    user = FactoryGirl.create :user
    expect_scheduled_job_to_have_run_in_the_future

    expect(ActionMailer::Base.deliveries).to_not be_empty
    email = ActionMailer::Base.deliveries.last
    expect(email.to_s).to_not include('translation missing')
    expect(email.to_s).to include(user.firstname)

    Timecop.return
    Delayed::Worker.delay_jobs = false
  end

  it 'sends personalised welcome emails from the email of the CEO' do
    user = FactoryGirl.create :user
    email = ActionMailer::Base.deliveries.first
    expect(email.from).to include('patrick.frank@voicerepublic.com')
  end

end
