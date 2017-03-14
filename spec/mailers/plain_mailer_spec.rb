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

  # Once an for all: The order in which emails are send is not
  # predictable, hence we'll collect all the addresses from all the
  # emails and check if the one we're looking for is included in the
  # list.
  it 'sends personalised welcome emails from the email of the CEO' do
    expect(ActionMailer::Base.deliveries).to be_empty
    FactoryGirl.create(:user)
    emails = ActionMailer::Base.deliveries.map(&:from).flatten
    expect(emails).to include('patrick.frank@voicerepublic.com')
  end

end
