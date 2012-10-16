require 'spec_helper'
require 'video_system_api/video_system_api'

describe VideoServer do
  it "has a valid factory do" do
    FactoryGirl.create(:video_server).should be_valid
  end
  it "has a valid deactivated server factory do" do
    FactoryGirl.create(:deactivated_video_server).should be_valid
  end    
  it "is invalid without salt" do
    FactoryGirl.build(:video_server, salt: nil).should_not be_valid
  end
  it "is invalid without name" do
    FactoryGirl.build(:video_server, name: nil).should_not be_valid
  end
  it "is invalid without url" do
    FactoryGirl.build(:video_server, url: nil).should_not be_valid
  end
  it "is invalid without version" do
    FactoryGirl.build(:video_server, version: nil).should_not be_valid
  end
  it "is invalid without http before url" do
    FactoryGirl.build(:video_server, url: 'www.foobar.com').should_not be_valid
  end
  it "is invalid with malformed url" do
    FactoryGirl.build(:video_server, url: 'http://www.foobar.com').should_not be_valid
  end
  it "is invalid with wrong version" do
    FactoryGirl.build(:video_server, version: '0.5').should_not be_valid
  end
  it "is invalid with non_unique name version" do
    FactoryGirl.create(:video_server, name: 'mama').should be_valid
    FactoryGirl.build(:video_server, name: 'mama').should_not be_valid
  end
  it "is invalid with non_unique name version" do
    FactoryGirl.create(:video_server, url: 'http://88.34.42.13/bigbluebutton/api').should be_valid
    FactoryGirl.build(:video_server, url: 'http://88.34.42.13/bigbluebutton/api').should_not be_valid
  end
  it "has associated rooms" do
    server = FactoryGirl.create(:video_server)
    server.video_rooms.should be_empty

    FactoryGirl.create(:video_room, :video_server => server)
    server = VideoServer.find(server.id)
    server.video_rooms.should_not be_empty
  end

  it "nullifies associated rooms" do
    server = FactoryGirl.create(:video_server)
    room = FactoryGirl.create(:video_room, :video_server => server)
    expect {
      expect {
        server.destroy
      }.to change{ VideoServer.count }.by(-1)
    }.to change{ VideoRoom.count }.by(0)
    VideoRoom.find(room.id).video_server_id.should == nil
  end
  
  context "has an api object" do
    let(:server) { server = FactoryGirl.build(:video_server) }
    it { should respond_to(:api) }
    it { server.api.should_not be_nil }
    it {
      server.save
      server.api.should_not be_nil
    }
    context "with the correct attributes" do
      let(:api) { api = VideoSystemApi::VideoSystemApi.new(server.url, server.salt, server.version, false, 2, '192.168.0.1') }
      it { server.api.should == api }

      # updating any of these attributes should update the api
      { :url => 'http://anotherurl.com/bigbluebutton/api',
        :salt => '12345-abcde-67890-fghijk', :version => '0.7' }.each do |k,v|
        it {
          server.send("#{k}=", v)
          server.api.send(k).should == v
        }
      end
    end
  end

  context "initializes" do
    let(:server) { VideoServer.new }

    it "fetched attributes before they are fetched" do
      server.video_system_rooms.should == []
    end
  end

  it { should respond_to(:fetch_video_system_rooms) }
  it { should respond_to(:video_system_rooms) }

  context "fetching info from video system" do
    let(:server) { FactoryGirl.create(:video_server) }
    let(:room1) { FactoryGirl.create(:video_room, name: 'room1', video_server: server, video_system_room_id: "room1") }
    let(:room2) { FactoryGirl.create(:video_room, name: 'room2', video_server: server, video_system_room_id: "room2") }

    # the hashes should be exactly as returned by bigbluebutton-api-ruby to be sure we are testing it right
    let(:video_system_rooms) {
      [
       { :meetingID => room1.video_system_room_id, :attendeePW => "ap", :moderatorPW => "mp", :hasBeenForciblyEnded => false, :running => true},
       { :meetingID => room2.video_system_room_id, :attendeePW => "pass", :moderatorPW => "pass", :hasBeenForciblyEnded => true, :running => false},
       { :meetingID => "im not in the db", :attendeePW => "pass", :moderatorPW => "pass", :hasBeenForciblyEnded => true, :running => true}
      ]
    }
    let(:hash) {
      { :returncode => true,
        :video_system_rooms => video_system_rooms
      }
    }

    before {
      @api_mock = mock(VideoSystemApi::VideoSystemApi)
      server.stub(:api).and_return(@api_mock)
      @api_mock.should_receive(:get_meetings).and_return(hash)
      server.fetch_video_system_rooms

      # the passwords are updated during fetch_meetings
      room1.moderator_password = "mp"
      room1.attendee_password = "ap"
      room2.moderator_password = "pass"
      room2.attendee_password = "pass"
    }

    it { server.video_system_rooms.count.should be(3) }
    it { server.video_system_rooms[0].should have_same_attributes_as(room1) }
    it { server.video_system_rooms[1].should have_same_attributes_as(room2) }
    it { server.video_system_rooms[2].video_system_room_id.should == "im not in the db" }
    it { server.video_system_rooms[2].name.should == "im not in the db" }
    it { server.video_system_rooms[2].video_server.should == server }
    it { server.video_system_rooms[2].attendee_password.should == "pass" }
    it { server.video_system_rooms[2].moderator_password.should == "pass" }
    it { server.video_system_rooms[2].running.should == true }
    it { server.video_system_rooms[2].new_record?.should be_true }
  end
end
