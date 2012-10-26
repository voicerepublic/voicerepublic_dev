require 'spec_helper'
require 'video_system_api'
require 'kluuu_exceptions'

describe VideoRoom do
  it "has a valid factory do" do
    FactoryGirl.create(:video_room).should be_valid
  end
  it "is invalid without video_server" do
    FactoryGirl.build(:video_room, video_server_id: nil).should_not be_valid
  end
  it "is invalid without video_session" do
    FactoryGirl.build(:video_room, video_session_id: nil).should_not be_valid
  end
  it "is invalid without name" do
    FactoryGirl.build(:video_room, name: nil).should_not be_valid
  end
  it "is invalid without guest password" do
    FactoryGirl.build(:video_room, guest_password: nil).should_not be_valid
  end
  it "is invalid without host password" do
    FactoryGirl.build(:video_room, host_password: nil).should_not be_valid
  end
  it "is invalid without video system room id" do
    FactoryGirl.build(:video_room, video_system_room_id: nil).should_not be_valid
  end
  it "is invalid with non_unique name" do
    r = FactoryGirl.create(:video_room, name: 'mama')
    FactoryGirl.build(:video_room, name: 'mama').should_not be_valid
  end
  it "is invalid with non_unique video system room id" do
    r = FactoryGirl.create(:video_room, video_system_room_id: 'sdahfgqkwlh43')
    FactoryGirl.build(:video_room, video_system_room_id: 'sdahfgqkwlh43').should_not be_valid
  end
  it "is invalid with too short video system room id" do
    FactoryGirl.build(:video_room, video_system_room_id: '').should_not be_valid
  end
  it "is invalid with too short name" do
    FactoryGirl.build(:video_room, name: '').should_not be_valid
  end
  it "is invalid with too long welcome_msg" do
    FactoryGirl.build(:video_room, welcome_msg: Faker::Lorem.characters(255)).should_not be_valid
  end
    
  # attr_accessors
  [:running, :participant_count, :participants,
   :has_been_forcibly_ended, :start_time, :end_time, :video_server].each do |attr|
    it { should respond_to(attr) }
    it { should respond_to("#{attr}=") }
  end

  it { should respond_to(:is_running?) }

  context "initializes" do
    let(:room) { VideoRoom.new }

    it "fetched attributes before they are fetched" do
      room.running.should be_false
      room.has_been_forcibly_ended.should be_false
      room.start_time.should be_nil
      room.participant_count.should be_nil
      room.end_time.should be_nil
      room.participants.should == []
    end

    context "video_system_room_id" do
      it { room.video_system_room_id.should be_nil }
    end
  end

  context "using the api" do
    before { mock_server_and_api }
    let(:video_session_1) { FactoryGirl.create(:video_session) }
    let(:room) { FactoryGirl.create(:video_room, video_session_id: video_session_1.id) }

    describe "#fetch_is_running?" do

      it { should respond_to(:fetch_is_running?) }

      context "fetches is_running? when not running" do
        before {
          mocked_api.should_receive(:is_meeting_running?).with(room.video_system_room_id).and_return(false)
          room.should_receive(:require_server)
          room.video_server = mocked_server
        }
        before(:each) { room.fetch_is_running? }
        it { room.running.should == false }
        it { room.is_running?.should == false }
      end

      context "fetches is_running? when running" do
        before {
          mocked_api.should_receive(:is_meeting_running?).with(room.video_system_room_id).and_return(true)
          room.should_receive(:require_server)
          room.video_server = mocked_server
        }
        before(:each) { room.fetch_is_running? }
        it { room.running.should == true }
        it { room.is_running?.should == true }
      end

    end

    describe "#fetch_video_system_room_info" do

      # these hashes should be exactly returned by our API to be sure we are testing it right
      let(:hash_info) {
        { :returncode=>true, :meetingID=>"test_id", :attendeePW=>"1234", :moderatorPW=>"4321",
          :running=>false, :hasBeenForciblyEnded=>false, :startTime=>nil, :endTime=>nil,
          :participantCount=>0, :moderatorCount=>0, :attendees=>[], :messageKey=>"", :message=>""
        }
      }
      let(:users) {
        [
         {:userID=>"ndw1fnaev0rj", :fullName=>"House M.D.", :role=>:moderator},
         {:userID=>"534", :fullName=>"Dexter Morgan", :role=>:moderator},
         {:userID=>"314", :fullName=>"Cameron Palmer", :role=>:viewer},
         {:userID=>"rbepbovolsxt", :fullName=>"Trinity", :role=>:viewer}
        ]
      }
      let(:hash_info2) {
        { :returncode=>true, :meetingID=>"test_id", :attendeePW=>"1234", :moderatorPW=>"4321",
          :running=>true, :hasBeenForciblyEnded=>false, :startTime=>DateTime.parse("Wed Apr 06 17:09:57 UTC 2011").to_time,
          :endTime=>nil, :participantCount=>4, :moderatorCount=>2,
          :attendees=>users, :messageKey=>{ }, :message=>{ }
        }
      }

      it { should respond_to(:fetch_video_system_room_info) }

      context "fetches meeting info when the meeting is not running" do
        before {
          mocked_api.should_receive(:get_meeting_info).
            with(room.video_system_room_id, room.host_password).and_return(hash_info)
          room.should_receive(:require_server)
          room.video_server = mocked_server
        }
        before(:each) { room.fetch_video_system_room_info }
        it { room.running.should == false }
        it { room.has_been_forcibly_ended.should == false }
        it { room.participant_count.should == 0 }
        it { room.start_time.should == nil }
        it { room.end_time.should == nil }
        it { room.participants.should == [] }
      end

      context "fetches meeting info when the meeting is running" do
        before {
          mocked_api.should_receive(:get_meeting_info).
            with(room.video_system_room_id, room.host_password).and_return(hash_info2)
          room.should_receive(:require_server)
          room.video_server = mocked_server
        }
        before(:each) { room.fetch_video_system_room_info }
        it { room.running.should == true }
        it { room.has_been_forcibly_ended.should == false }
        it { room.participant_count.should == 4 }
        it { room.start_time.should == DateTime.parse("Wed Apr 06 17:09:57 UTC 2011").to_time }
        it { room.end_time.should == nil }
        it {
          users.each do |att|
            participant = VideoSystemApi::VideoSystemParticipant.new
            participant.from_hash(att)
            room.participants.should include(participant)
          end
        }
      end
    end

    describe "#send_end" do
      it { should respond_to(:send_end) }

      it "send end_meeting" do
        mocked_api.should_receive(:end_meeting).with(room.video_system_room_id, room.host_password)
        room.should_receive(:require_server)
        room.video_server = mocked_server
        room.send_end
      end
    end

    describe "#send_create" do
      let(:guest_password) { Faker::Lorem.characters(8) }
      let(:host_password) { Faker::Lorem.characters(8) }
      let(:hash_create) {
        {
          :returncode => "SUCCESS", :meetingID => "test_id",
          :attendeePW => guest_password, :moderatorPW => host_password,
          :hasBeenForciblyEnded => "false", :messageKey => {}, :message => {}
        }
      }
      before {
        room.update_attributes(:welcome_msg => "Anything")
        mocked_api.should_receive(:"request_headers=").any_number_of_times.with({})
      }

      it { should respond_to(:send_create) }

      context "calls #default_welcome_msg if welcome_msg is" do
        before do
          room.should_receive(:default_welcome_message).and_return("Hi!")
          mocked_api.should_receive(:create_meeting).
            with(anything, anything, "Hi!", anything, anything, anything, anything)
          room.stub(:select_server).and_return(mocked_server)
          room.video_server = mocked_server
        end

        context "nil" do
          before { room.welcome_msg = nil }
          it { room.send_create }
        end
        context "empty" do
          before { room.welcome_msg = "" }
          it { room.send_create }
        end
      end

      context "sends create_meeting" do

        context "for a stored room" do
          before do
            mocked_api.should_receive(:create_meeting).
              with(room.name, anything, room.welcome_msg, 
                   room.video_session.klu.get_charge_type_as_integer, 
                   room.video_session.klu.free_time,
                   dollarize(room.video_session.klu.charge_amount), 
                   room.video_session.klu.currency).and_return(hash_create)
            room.stub(:select_server).and_return(mocked_server)
            room.video_server = mocked_server
            room.send_create
          end
          it { room.guest_password.should be(guest_password) }
          it { room.host_password.should be(host_password) }
          it { room.changed?.should be_false }
        end

        context "for a new record" do
          let(:video_session_3) { FactoryGirl.create(:video_session) }
          let(:new_room) { FactoryGirl.build(:video_room, video_session_id: video_session_3.id) }
          before do
            mocked_api.should_receive(:create_meeting).
              with(new_room.name, anything, new_room.welcome_msg, 
                   new_room.video_session.klu.get_charge_type_as_integer, 
                   new_room.video_session.klu.free_time,
                   dollarize(new_room.video_session.klu.charge_amount), 
                   new_room.video_session.klu.currency).and_return(hash_create)
            new_room.stub(:select_server).and_return(mocked_server)
            new_room.video_server = mocked_server
            new_room.send_create
          end
          it { new_room.guest_password.should be(guest_password) }
          it { new_room.host_password.should be(host_password) }
          it("and do not save the record") { new_room.new_record?.should be_true }
        end
      end

      context "randomizes meetingid" do
        let(:fail_hash) { { :returncode => true, :meetingID => "new id", :messageKey => "duplicateWarning" } }
        let(:success_hash) { { :returncode => true, :meetingID => "new id", :messageKey => "" } }
        let(:new_id) { "new id" }
        before {
          room.stub(:select_server).and_return(mocked_server)
          room.video_server = mocked_server
        }

        it "before calling create" do
          room.should_receive(:random_video_system_room_id).and_return(new_id)
          mocked_api.should_receive(:create_meeting).
            with(room.name, new_id, room.welcome_msg, 
                   room.video_session.klu.get_charge_type_as_integer, 
                   room.video_session.klu.free_time,
                   dollarize(room.video_session.klu.charge_amount), 
                   room.video_session.klu.currency)
          room.send_create
        end

        it "and tries again on error" do
          # fails twice and then succeds
          room.should_receive(:random_video_system_room_id).exactly(3).times.and_return(new_id)
          mocked_api.should_receive(:create_meeting).
            with(room.name, new_id, room.welcome_msg, 
                   room.video_session.klu.get_charge_type_as_integer, 
                   room.video_session.klu.free_time,
                   dollarize(room.video_session.klu.charge_amount), 
                   room.video_session.klu.currency).twice.and_return(fail_hash)
          mocked_api.should_receive(:create_meeting).
            with(room.name, new_id, room.welcome_msg, 
                   room.video_session.klu.get_charge_type_as_integer, 
                   room.video_session.klu.free_time,
                   dollarize(room.video_session.klu.charge_amount), 
                   room.video_session.klu.currency).once.and_return(success_hash)
          room.send_create
        end

        it "and limits to 10 tries" do
          room.should_receive(:random_video_system_room_id).exactly(11).times.and_return(new_id)
          mocked_api.should_receive(:create_meeting).
            with(room.name, new_id, room.welcome_msg, 
                   room.video_session.klu.get_charge_type_as_integer, 
                   room.video_session.klu.free_time,
                   dollarize(room.video_session.klu.charge_amount), 
                   room.video_session.klu.currency).exactly(10).times.and_return(fail_hash)
          room.send_create
        end
      end

      context "selects and requires a server" do
        let(:another_server) { FactoryGirl.create(:video_server) }

        context "and saves the result" do
          before do
            room.should_receive(:select_server).and_return(another_server)
            room.should_receive(:require_server)
            room.should_receive(:do_create_video_system_room)
            room.video_server = mocked_server
            room.send_create
          end
          it { VideoRoom.find(room.id).video_server_id.should == another_server.id }
        end

        context "and does not save when is a new record" do
          let(:video_session_2) { FactoryGirl.create(:video_session) }
          let(:new_room) { FactoryGirl.build(:video_room, video_session_id: video_session_2.id) }
          before do
            new_room.should_receive(:select_server).and_return(another_server)
            new_room.should_receive(:require_server)
            new_room.should_receive(:do_create_video_system_room).and_return(nil)
            new_room.should_not_receive(:save)
            new_room.video_server = mocked_server
            new_room.send_create
          end
          it { new_room.new_record?.should be_true }
        end
      end
    end # #send_create

    describe "#join_url" do
      let(:username) { Faker::Name.first_name }
      let(:user_id) { 1508 }

      it { should respond_to(:join_url) }

      context do
        before { room.should_receive(:require_server) }

        it "with host role" do
          mocked_api.should_receive(:join_meeting_url).
            with(room.video_system_room_id, username, room.host_password, user_id)
          room.video_server = mocked_server
          room.join_url(username, :host, user_id)
        end

        it "with guest role" do
          mocked_api.should_receive(:join_meeting_url).
            with(room.video_system_room_id, username, room.guest_password, user_id)
          room.video_server = mocked_server
          room.join_url(username, :guest, user_id)
        end
      end
    end
  end

  describe "#require_server" do
    let(:room) { FactoryGirl.create(:video_room) }
    it { should respond_to(:require_server) }

    context "throws exception when the room has no server associated" do
      before { room.video_server = nil }
      it {
        lambda {
          room.send(:require_server)
        }.should raise_error(KluuuExceptions::VideoSystemError)
      }
    end

    context "does nothing if the room has a server associated" do
      before { room.video_server = FactoryGirl.create(:video_server) }
      it {
        lambda {
          room.send(:require_server)
        }.should_not raise_error(KluuuExceptions::VideoSystemError)
      }
    end
  end

  describe "#select_server" do
    let(:room) { FactoryGirl.build(:video_room, video_server: nil) }
    it { should respond_to(:select_server) }

    context "selects the server with less rooms" do
      before {
        VideoServer.destroy_all
        s1 = FactoryGirl.create(:video_server)
        @s2 = FactoryGirl.create(:video_server)
        3.times{ FactoryGirl.create(:video_room, video_server: s1) }
        2.times{ FactoryGirl.create(:video_room, video_server: @s2) }
      }
      it { room.send(:select_server).should == @s2 }
    end

    context "returns nil if there are no servers" do
      before(:each) { VideoServer.destroy_all }
      it { room.send(:select_server).should == nil }
    end
    
    context "selects next video server if selected server is not available" do
      pending 'move server detection from sezzion model here'
    end
    
    context "switches video server to deactivated if it is not available" do
      pending 'move server detection from sezzion model here'
    end
    
    context "informs administrators if video server gets deactivated" do
      pending 'move server detection from sezzion model here'
    end
  end
end
