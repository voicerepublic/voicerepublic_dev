require 'spec_helper'  

describe Participant::GuestRegistered do
    
  before do
    
    if User.find_by_email('admin@kluuu.com').nil?
      @kluuu_user = User.create!(:firstname => 'kluuu', :lastname => 'master', :email => 'admin@kluuu.com', :password => 'aendere_mich', :password_confirmation => 'aendere_mich')
    end
    if @kluuu_user.balance_account.nil?
      Balance::Account.create!(:user_id => @kluuu_user.id, :currency => 'EUR')
    end
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
    before do
      
      @host_user = FactoryGirl.create(:user)
      @host_balance_account =  FactoryGirl.create(:balance_account, currency: 'EUR', user: @host_user)
      @klu_minute = FactoryGirl.create(:published_kluuu, charge_cents: 200, charge_type: 'minute', user: @host_user)
      @guest_user = FactoryGirl.create(:user)
      @guest_balance_account =  FactoryGirl.create(:balance_account, currency: 'EUR', user: @guest_user)
      @video_session_minute = FactoryGirl.create(:kluuu_registered_video_session, klu: @klu_minute, calling_user_id: @guest_user.id)
      
    end   
    
    
    context "and when the pay per minute klu session is correctly initialized" do  
      it "has the foreseen participants" do
        @video_session_minute.host_participant.user.should eq(@host_user)
        @video_session_minute.guest_participant.user.should eq(@guest_user)
      end
    end
    
    context "and after 4 minutes the payment is stopped" do
      it "and he has to pay for nothing" do
        @video_session_minute.host_participant.update_attributes(:entered_timestamp => 7.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:entered_timestamp => 7.minutes.ago, :payment_started_timestamp => 7.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(25000,'EUR'))
        @host_user.balance_account.revenue.should eq(Money.new(0,'EUR'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(0,'EUR'))
        @video_session_minute.guest_participant.reload
        @video_session_minute.guest_participant.payment_started_timestamp.should == nil
        @video_session_minute.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_minute.guest_participant.seconds_online.should == 240
      end
    end
    
    context "and then the payment starts again for two minutes" do
      before do
        @video_session_minute.host_participant.update_attributes(:entered_timestamp => 7.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:entered_timestamp => 7.minutes.ago, :payment_started_timestamp => 7.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
      end
      
      it "and he has to pay for two more minutes" do
        @video_session_minute.guest_participant.reload
        @video_session_minute.guest_participant.update_attributes(:payment_started_timestamp => 2.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:payment_stopped_timestamp => Time.now)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(24600,'EUR'))
        @host_user.balance_account.revenue.should eq(Money.new(324,'EUR'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(76,'EUR'))
        @video_session_minute.guest_participant.reload
        @video_session_minute.guest_participant.payment_started_timestamp.should == nil
        @video_session_minute.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_minute.guest_participant.seconds_online.should == 360
      end
    end
    
    context "and after 6 minutes the payment is stopped" do
     
      it "and he has to pay for two minutes" do
        @video_session_minute.host_participant.update_attributes(:entered_timestamp => 9.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:entered_timestamp => 9.minutes.ago, :payment_started_timestamp => 9.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(24600,'EUR'))
        @host_user.balance_account.revenue.should eq(Money.new(324,'EUR'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(76,'EUR'))
        @video_session_minute.guest_participant.reload
        @video_session_minute.guest_participant.payment_started_timestamp.should == nil
        @video_session_minute.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_minute.guest_participant.seconds_online.should == 360
      end
    end
    
    context "and then the payment starts again for two minutes" do
      before do
        @video_session_minute.host_participant.update_attributes(:entered_timestamp => 9.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:entered_timestamp => 9.minutes.ago, :payment_started_timestamp => 9.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
      end
      
      it "and he has to pay for two more minutes" do
        @video_session_minute.guest_participant.reload
        @video_session_minute.guest_participant.update_attributes(:payment_started_timestamp => 2.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:payment_stopped_timestamp => Time.now)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(24200,'EUR'))
        @host_user.balance_account.revenue.should eq(Money.new(648,'EUR'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(152,'EUR'))
        @video_session_minute.guest_participant.reload
        @video_session_minute.guest_participant.payment_started_timestamp.should == nil
        @video_session_minute.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_minute.guest_participant.seconds_online.should == 480
      
      end
    end
      
  end

  describe "a guest participant attends a pay fix klu session" do
    before do
      
      @host_user = FactoryGirl.create(:user)
      @host_balance_account =  FactoryGirl.create(:balance_account, currency: 'EUR', user: @host_user)
      @klu_fix = FactoryGirl.create(:published_kluuu, charge_cents: 2000, charge_type: 'fix', user: @host_user)
      @guest_user = FactoryGirl.create(:user)
      @guest_balance_account =  FactoryGirl.create(:balance_account, currency: 'EUR', user: @guest_user)
      @video_session_fix = FactoryGirl.create(:kluuu_registered_video_session, klu: @klu_fix, calling_user_id: @guest_user.id)
    
    end
    
    
    context "and when the pay per minute klu session is correctly initialized" do  
      
      it "has the foreseen participants" do
        @video_session_fix.host_participant.user.should eq(@host_user)
        @video_session_fix.guest_participant.user.should eq(@guest_user)
    
      end
    
    end
    
    context "and after 4 minutes the payment is stopped" do
      it "and he has to pay for nothing" do
        @video_session_fix.host_participant.update_attributes(:entered_timestamp => 7.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:entered_timestamp => 7.minutes.ago, :payment_started_timestamp => 7.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(25000,'EUR'))
        @host_user.balance_account.revenue.should eq(Money.new(0,'EUR'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(0,'EUR'))
        @video_session_fix.guest_participant.reload
        @video_session_fix.guest_participant.payment_started_timestamp.should == nil
        @video_session_fix.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_fix.guest_participant.seconds_online.should == 240
      end
    end
    
    context "and then the payment starts again for two minutes" do
      before do
        @video_session_fix.host_participant.update_attributes(:entered_timestamp => 7.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:entered_timestamp => 7.minutes.ago, :payment_started_timestamp => 7.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
      end
      
      it "and he has to pay for two more minutes" do
        @video_session_fix.guest_participant.reload
        @video_session_fix.guest_participant.update_attributes(:payment_started_timestamp => 2.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:payment_stopped_timestamp => Time.now)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(23000,'EUR'))
        @host_user.balance_account.revenue.should eq(Money.new(1620,'EUR'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(380,'EUR'))
        @video_session_fix.guest_participant.reload
        @video_session_fix.guest_participant.payment_started_timestamp.should == nil
        @video_session_fix.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_fix.guest_participant.seconds_online.should == 360
      end
    end
    
    context "and after 6 minutes the payment stops" do
     
      it "has to pay the fix price" do
        @video_session_fix.host_participant.update_attributes(:entered_timestamp => 9.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:entered_timestamp => 9.minutes.ago, :payment_started_timestamp => 9.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(23000,'EUR'))
        @host_user.balance_account.revenue.should eq(Money.new(1620,'EUR'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(380,'EUR'))
        @video_session_fix.guest_participant.reload
        @video_session_fix.guest_participant.payment_started_timestamp.should == nil
        @video_session_fix.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_fix.guest_participant.seconds_online.should == 360
      end
    
    end
    
    context "then payment starts again for 2 minutes" do
      
      before do
        @video_session_fix.host_participant.update_attributes(:entered_timestamp => 9.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:entered_timestamp => 9.minutes.ago, :payment_started_timestamp => 9.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
      end
      
      it "and the participant has to pay nothing" do
        @video_session_fix.guest_participant.reload
        @video_session_fix.guest_participant.update_attributes(:payment_started_timestamp => 2.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:payment_stopped_timestamp => Time.now)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(23000,'EUR'))
        @host_user.balance_account.revenue.should eq(Money.new(1620,'EUR'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(380,'EUR'))
        @video_session_fix.guest_participant.reload
        @video_session_fix.guest_participant.payment_started_timestamp.should == nil
        @video_session_fix.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_fix.guest_participant.seconds_online.should == 480
      
      end
    
    end  
    
  end
  
  describe "a guest participant attends an international pay per minute klu session" do
    before do
      
      @host_user = FactoryGirl.create(:user)
      @host_balance_account =  FactoryGirl.create(:balance_account, currency: 'USD', user: @host_user)
      @klu_minute = FactoryGirl.create(:published_kluuu, charge_cents: 200, charge_type: 'minute', user: @host_user)
      @guest_user = FactoryGirl.create(:user)
      @guest_balance_account =  FactoryGirl.create(:balance_account, currency: 'EUR', user: @guest_user)
      @video_session_minute = FactoryGirl.create(:kluuu_registered_video_session, klu: @klu_minute, calling_user_id: @guest_user.id)
      
    end
    
    
    context "and when the pay per minute klu session is correctly initialized" do  
      it "has the foreseen participants" do
        @video_session_minute.host_participant.user.should eq(@host_user)
        @video_session_minute.guest_participant.user.should eq(@guest_user)
      end
    end
    
    context "and after 6 minutes the payment is stopped" do
     
      it "and he has to pay for two minutes" do
        @video_session_minute.host_participant.update_attributes(:entered_timestamp => 9.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:entered_timestamp => 9.minutes.ago, :payment_started_timestamp => 9.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(25000,'EUR') - Money.new(400,'USD'))
        @host_user.balance_account.revenue.should eq(Money.new(324,'USD'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(400,'USD').exchange_to('EUR') * 19/100)
        @video_session_minute.guest_participant.reload
        @video_session_minute.guest_participant.payment_started_timestamp.should == nil
        @video_session_minute.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_minute.guest_participant.seconds_online.should == 360
      end
    end
    
    context "and then the payment starts again for two minutes" do
      before do
        @video_session_minute.host_participant.update_attributes(:entered_timestamp => 9.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:entered_timestamp => 9.minutes.ago, :payment_started_timestamp => 9.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
      end
      
      it "and he has to pay for two more minutes" do
        @video_session_minute.guest_participant.reload
        @video_session_minute.guest_participant.update_attributes(:payment_started_timestamp => 2.minutes.ago)
        @video_session_minute.guest_participant.update_attributes(:payment_stopped_timestamp => Time.now)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(25000,'EUR') - Money.new(800,'USD'))
        @host_user.balance_account.revenue.should eq(Money.new(648,'USD'))
        @kluuu_user.balance_account.revenue.should be_within(1).of(Money.new(800,'USD').exchange_to('EUR') * 19/100)
        @video_session_minute.guest_participant.reload
        @video_session_minute.guest_participant.payment_started_timestamp.should == nil
        @video_session_minute.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_minute.guest_participant.seconds_online.should == 480
      
      end
    end
      
  end

  describe "a guest participant attends an international pay fix klu session" do
    before do
      
      @host_user = FactoryGirl.create(:user)
      @host_balance_account =  FactoryGirl.create(:balance_account, currency: 'USD', user: @host_user)
      @klu_fix = FactoryGirl.create(:published_kluuu, charge_cents: 2000, charge_type: 'fix', user: @host_user)
      @guest_user = FactoryGirl.create(:user)
      @guest_balance_account =  FactoryGirl.create(:balance_account, currency: 'EUR', user: @guest_user)
      @video_session_fix = FactoryGirl.create(:kluuu_registered_video_session, klu: @klu_fix, calling_user_id: @guest_user.id)
    
    end
    
    
    context "and when the pay fix klu session is correctly initialized" do  
      
      it "has the foreseen participants" do
        @video_session_fix.host_participant.user.should eq(@host_user)
        @video_session_fix.guest_participant.user.should eq(@guest_user)
    
      end
    
    end
    
    context "and after 6 minutes the payment stops" do
     
      it "has to pay the fix price" do
        @video_session_fix.host_participant.update_attributes(:entered_timestamp => 9.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:entered_timestamp => 9.minutes.ago, :payment_started_timestamp => 9.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(25000,'EUR') - Money.new(2000,'USD'))
        @host_user.balance_account.revenue.should eq(Money.new(1620,'USD'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(2000,'USD').exchange_to('EUR') * 19/100)
        @video_session_fix.guest_participant.reload
        @video_session_fix.guest_participant.payment_started_timestamp.should == nil
        @video_session_fix.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_fix.guest_participant.seconds_online.should == 360
      end
    
    end
    
    context "then payment starts again for 2 minutes" do
      
      before do
        @video_session_fix.host_participant.update_attributes(:entered_timestamp => 9.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:entered_timestamp => 9.minutes.ago, :payment_started_timestamp => 9.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:payment_stopped_timestamp => 3.minutes.ago)
      end
      
      it "and the participant has to pay nothing" do
        @video_session_fix.guest_participant.reload
        @video_session_fix.guest_participant.update_attributes(:payment_started_timestamp => 2.minutes.ago)
        @video_session_fix.guest_participant.update_attributes(:payment_stopped_timestamp => Time.now)
        @guest_user.reload
        @host_user.reload
        @kluuu_user.reload
        @guest_user.balance_account.balance.should eq(Money.new(25000,'EUR') - Money.new(2000,'USD'))
        @host_user.balance_account.revenue.should eq(Money.new(1620,'USD'))
        @kluuu_user.balance_account.revenue.should eq(Money.new(2000,'USD').exchange_to('EUR') * 19/100)
        @video_session_fix.guest_participant.reload
        @video_session_fix.guest_participant.payment_started_timestamp.should == nil
        @video_session_fix.guest_participant.payment_stopped_timestamp.should == nil
        @video_session_fix.guest_participant.seconds_online.should == 480
      end
    
    end
  end
end
