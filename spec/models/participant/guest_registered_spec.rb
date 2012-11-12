require 'spec_helper'  

describe Participant::GuestRegistered do
    
  before do
    
    if User.find_by_email('admin@kluuu.com').nil?
      @kluuu_user = User.create!(:firstname => 'kluuu', :lastname => 'master', :email => 'admin@kluuu.com', :password => 'aendere_mich', :password_confirmation => 'aendere_mich')
    end
    if @kluuu_user.balance_account.nil?
      Balance::Account.create!(:user_id => @kluuu_user.id, :currency => 'EUR')
    end
    @host_user = FactoryGirl.create(:user)
    @host_balance_account =  FactoryGirl.create(:balance_account, currency: 'EUR', user: @host_user)
    @klu = FactoryGirl.create(:published_kluuu, charge_amount: 200, charge_type: 'minute', user: @host_user)
    @guest_user = FactoryGirl.create(:user)
    @guest_balance_account =  FactoryGirl.create(:balance_account, currency: 'EUR', user: @guest_user)
    @video_session = FactoryGirl.create(:kluuu_registered_video_session, klu: @klu, calling_user_id: @guest_user.id)
  end
      
    
  it "has a valid guest participant factory" do
    FactoryGirl.create(:guest_participant_registered).should be_valid
  end
  it "is invalid without an type" do
    FactoryGirl.build(:guest_participant_registered, type: nil).should_not be_valid
  end
  it "is invalid without video_session_id" do
    FactoryGirl.build(:guest_participant_registered, video_session_id: nil).should_not be_valid
  end
  it "is invalid without video_session_role" do
    FactoryGirl.build(:guest_participant_registered, video_session_role: nil).should_not be_valid
  end
  it "is invalid without user_id" do
    FactoryGirl.build(:guest_participant_registered, user_id: nil).should_not be_valid
  end
  it "is valid with user" do
    p = FactoryGirl.create(:guest_participant_registered)
    p.user.should be_valid
  end
  
  describe "a guest participant attends a pay per minute klu session" do
    
    context "and when the pay per minute klu session is correctly initialized" do  
      it "has the foreseen participants" do
        @video_session.host_participant.user.should eq(@host_user)
        @video_session.guest_participant.user.should eq(@guest_user)
      end
    end
    
    context "and after 6 minutes he leaves" do
     
      it "has to pay for one minute" do
        @video_session.host_participant.update_attributes(:entered_timestamp => 6.minutes.ago)
        @video_session.guest_participant.update_attributes(:entered_timestamp => 6.minutes.ago, :payment_started_timestamp => 6.minutes.ago)
        @video_session.guest_participant.update_attributes(:payment_stopped_timestamp => Time.now)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(24600,'EUR'))
        @host_user.balance_account.revenue.should eq(Money.new(324,'EUR'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(76,'EUR'))
      end
    end
      
  end
end
