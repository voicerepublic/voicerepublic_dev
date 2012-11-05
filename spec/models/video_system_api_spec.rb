require 'video_system_api/video_system_api'
require 'date'

describe VideoSystemApi::VideoSystemApi do

  # default variables and API object for all tests
  let(:url) { "http://server.com" }
  let(:salt) { "1234567890abcdefghijkl" }
  let(:version) { "0.7" }
  let(:debug) { false }
  let(:timeout) { 2 }
  let(:ip) { '192.168.0.1' }
  let(:port) { '3000' }
  let(:api) { VideoSystemApi::VideoSystemApi.new(url, salt, version, debug, timeout, ip, port) }

  describe "#initialize" do
    context "standard initialization" do
      subject { VideoSystemApi::VideoSystemApi.new(url, salt, version, debug, timeout, ip, port) }
      it { subject.url.should be(url) }
      it { subject.salt.should be(salt) }
      it { subject.version.should be(version) }
      it { subject.debug.should be(debug) }
      it { subject.timeout.should be(timeout) }
      it { subject.ip.should be(ip) }
      it { subject.port.should be(port) }
      it { subject.supported_versions.should include("0.7") }
    end

    context "when the version is not informed, get it from the BBB server" do
      before { VideoSystemApi::VideoSystemApi.any_instance.should_receive(:get_api_version).and_return("0.7") }
      subject { VideoSystemApi::VideoSystemApi.new(url, salt, nil) }
      it { subject.version.should == "0.7" }
    end

    it "when the version is not supported raise an error" do
      expect {
        VideoSystemApi::VideoSystemApi.new(url, salt, "0.not-supported", nil)
      }.to raise_error(VideoSystemApi::VideoSystemApiException)
    end

    context "current supported versions" do
      subject { VideoSystemApi::VideoSystemApi.new(url, salt) }
      it { subject.supported_versions.should == ["0.7"] }
    end
  end

  describe "#join_meeting_url" do
    let(:meeting_id) { "meeting-id" }
    let(:password) { "password" }
    let(:user_name) { "user-name" }
    let(:user_id) { "user-id" }
    let(:params) {
      { :meetingID => meeting_id, :password => password, :fullName => user_name,
        :userID => user_id}
    }

    before { api.should_receive(:get_url).with(:join, params).and_return("test-url") }
    it { api.join_meeting_url(meeting_id, user_name, password, user_id).should == "test-url" }
  end

  describe "#create_meeting" do
    let(:meeting_name) { "name" }
    let(:meeting_id) { "meeting-id" }
    let(:moderator_password) { nil }
    let(:attendee_password) { nil }
    let(:welcome_message) { "welcome" }
    let(:dial_number) { nil }
    let(:logout_url) { "http://www.kluuu.com" }
    let(:max_participants) { 2 }
    let(:voice_bridge) { 72879 }
    let(:kluuuIp) { ip }
    let(:kluuuPort) { port }
    let(:tt) { 1 }
    let(:ttp) { 5 }
    let(:charge_amount) { 2.99 }
    let(:currency) { 'EUR' }
    let(:params) {
               { :name => meeting_name, :meetingID => meeting_id,
                 :moderatorPW => moderator_password, :attendeePW => attendee_password,
                 :welcome => welcome_message, :dialNumber => dial_number,
                 :logoutURL => logout_url, :maxParticpants => max_participants,
                 :voiceBridge => voice_bridge, :kluuuIp => ip, :kluuuPort => port,
                 :tt => tt, :ttp => ttp, 
                 :charge => charge_amount, :currency => currency }
    }
    let(:response) { { :meetingID => 123, :moderatorPW => 111, :attendeePW => 222, :hasBeenForciblyEnded => "FALSE" } }
    let(:expected_response) { { :meetingID => "123", :moderatorPW => "111", :attendeePW => "222", :hasBeenForciblyEnded => false } }

    # ps: not mocking the formatter here because it's easier to just check the results (expected_response)
    before { api.should_receive(:send_api_request).with(:create, params).and_return(response) }
    subject { api.create_meeting(meeting_name, meeting_id, welcome_message, tt, ttp, charge_amount, currency) }
    it { subject.should == expected_response }
  end

  describe "#end_meeting" do
    let(:meeting_id) { "meeting-id" }
    let(:moderator_password) { "password" }
    let(:params) { { :meetingID => meeting_id, :password => moderator_password } }
    let(:response) { "anything" }

    before { api.should_receive(:send_api_request).with(:end, params).and_return(response) }
    it { api.end_meeting(meeting_id, moderator_password).should == response }
  end

  describe "#is_meeting_running?" do
    let(:meeting_id) { "meeting-id" }
    let(:params) { { :meetingID => meeting_id } }

    context "when the meeting is running" do
      let(:response) { { :running => "TRUE" } }
      before { api.should_receive(:send_api_request).with(:isMeetingRunning, params).and_return(response) }
      it { api.is_meeting_running?(meeting_id).should == true }
    end

    context "when the meeting is not running" do
      let(:response) { { :running => "FALSE" } }
      before { api.should_receive(:send_api_request).with(:isMeetingRunning, params).and_return(response) }
      it { api.is_meeting_running?(meeting_id).should == false }
    end
  end

  describe "#get_meeting_info" do
    let(:meeting_id) { "meeting-id" }
    let(:password) { "password" }
    let(:params) { { :meetingID => meeting_id, :password => password } }

    let(:attendee1) { { :userID => 123, :fullName => "Dexter Morgan", :role => "MODERATOR" } }
    let(:attendee2) { { :userID => "id2", :fullName => "Cameron", :role => "VIEWER" } }
    let(:response) {
      { :meetingID => 123, :moderatorPW => 111, :attendeePW => 222, :hasBeenForciblyEnded => "FALSE",
        :running => "TRUE", :startTime => DateTime.parse("Thu Sep 01 17:51:42 UTC 2011").to_time.to_i, :endTime => "NULL",
        :returncode => true, :attendees => { :attendee => [ attendee1, attendee2 ] }, :messageKey => "mkey", :message => "m" }
    } # hash after the send_api_request call, before the specific formatting

    let(:expected_attendee1) { { :userID => "123", :fullName => "Dexter Morgan", :role => :moderator } }
    let(:expected_attendee2) { { :userID => "id2", :fullName => "Cameron", :role => :viewer } }
    let(:expected_response) {
      { :meetingID => "123", :moderatorPW => "111", :attendeePW => "222", :hasBeenForciblyEnded => false,
        :running => true, :startTime => DateTime.parse("Thu Sep 01 17:51:42 UTC 2011").to_time, :endTime => nil,
        :returncode => true, :attendees => [ expected_attendee1, expected_attendee2 ], :messageKey => "mkey", :message => "m" }
    } # expected return hash after all the formatting

    # ps: not mocking the formatter here because it's easier to just check the results (expected_response)
    before { api.should_receive(:send_api_request).with(:getMeetingInfo, params).and_return(response) }
    it { api.get_meeting_info(meeting_id, password).should == expected_response }
  end

  describe "#get_meetings" do
    let(:meeting_hash1) { { :meetingID => "Demo Meeting", :attendeePW => "ap", :moderatorPW => "mp", :hasBeenForciblyEnded => false, :running => true } }
    let(:meeting_hash2) { { :meetingID => "Ended Meeting", :attendeePW => "pass", :moderatorPW => "pass", :hasBeenForciblyEnded => true, :running => false } }
    let(:flattened_response) {
      { :returncode => true, :meetings => [ meeting_hash1, meeting_hash2 ], :messageKey => "mkey", :message => "m" }
    } # hash *after* the flatten_objects call

    before {
      # FIXME: how to expect a hash with a random value in the should_receive below?
      api.should_receive(:send_api_request).with(:getMeetings, anything).and_return(flattened_response)
      formatter_mock = mock(VideoSystemApi::VideoSystemApiFormatter)
      formatter_mock.should_receive(:flatten_objects).with(:meetings, :meeting)
      formatter_mock.should_receive(:format_meeting).with(meeting_hash1)
      formatter_mock.should_receive(:format_meeting).with(meeting_hash2)
      VideoSystemApi::VideoSystemApiFormatter.should_receive(:new).and_return(formatter_mock)
    }
    it { api.get_meetings }
  end

  describe "#get_api_version" do
    context "returns the version returned by the server" do
      let(:hash) { { :returncode => true, :version => "0.7" } }
      before { api.should_receive(:send_api_request).with(:index).and_return(hash) }
      it { api.get_api_version.should == "0.7" }
    end

    context "returns an empty string when the server responds with an empty hash" do
      before { api.should_receive(:send_api_request).with(:index).and_return({}) }
      it { api.get_api_version.should == "" }
    end
  end

  describe "#test_connection" do
    context "returns the returncode returned by the server" do
      let(:hash) { { :returncode => "any-value" } }
      before { api.should_receive(:send_api_request).with(:index).and_return(hash) }
      it { api.test_connection.should == "any-value" }
    end
  end

  describe "#==" do
    let(:api2) { VideoSystemApi::VideoSystemApi.new(url, salt, version, debug, 2) }

    context "compares attributes" do
      it { api.should == api2 }
    end

    context "differs #debug" do
      before { api2.debug = !api.debug }
      it { api.should_not == api2 }
    end

    context "differs #salt" do
      before { api2.salt = api.salt + "x" }
      it { api.should_not == api2 }
    end

    context "differs #version" do
      before { api2.version = api.version + "x" }
      it { api.should_not == api2 }
    end

    context "differs #supported_versions" do
      before { api2.supported_versions << "x" }
      it { api.should_not == api2 }
    end
  end

  describe "#last_http_response" do
    # we test this through a #test_connection call

    let(:request_mock) { mock }
    before {
      api.should_receive(:get_url)
      # this return value will be stored in @http_response
      api.should_receive(:send_request).and_return(request_mock)
      # to return fast from #send_api_request
      request_mock.should_receive(:body).and_return("")
      api.test_connection
    }
    it { api.last_http_response.should == request_mock }
  end

  describe "#get_url" do

    context "when method = :index" do
      it { api.get_url(:index).should == api.url }
    end

    context "when method != :index" do
      context "validates the entire url" do
        context "with params" do
          let(:params) { { :param1 => "value1", :param2 => "value2" } }
          subject { api.get_url(:join, params) }
          it { subject.should match(/#{url}\/join\?param1=value1&param2=value2/) }
        end

        context "without params" do
          subject { api.get_url(:join) }
          it { subject.should match(/#{url}\/join\?[^&]/) }
        end
      end

      context "discards params with nil value" do
        let(:params) { { :param1 => "value1", :param2 => nil } }
        subject { api.get_url(:join, params) }
        it { subject.should_not match(/param2=/) }
      end

      context "escapes all params" do
        let(:params) { { :param1 => "value with spaces", :param2 => "@$" } }
        subject { api.get_url(:join, params) }
        it { subject.should match(/param1=value\+with\+spaces/) }
        it { subject.should match(/param2=%40%24/) }
      end

      context "includes the checksum" do
        let(:params) { { :param1 => "value1", :param2 => "value2" } }
        let(:checksum) { Digest::SHA1.hexdigest("joinparam1=value1&param2=value2#{salt}") }
        subject { api.get_url(:join, params) }
        it { subject.should match(/checksum=#{checksum}$/) }
      end
    end
  end

  # FIXME: this complex test means that the method is too complex - try to refactor it
  describe "#send_api_request" do
    let(:method) { :join }
    let(:params) { { :param1 => "value1" } }
    let(:target_url) { "http://test-server:8080?param1=value1&checksum=12345" }
    let(:make_request) { api.send_api_request(method, params) }
    before { api.should_receive(:get_url).with(method, params).and_return(target_url) }

    def setup_http_mock
      @http_mock = mock(Net::HTTP)
      Net::HTTP.should_receive(:new).with("test-server", 8080).and_return(@http_mock)
      @http_mock.should_receive(:"open_timeout=").with(api.timeout)
      @http_mock.should_receive(:"read_timeout=").with(api.timeout)
    end

    context "sets up the Net::HTTP object correctly" do
      before do
        setup_http_mock
        response_mock = mock()
        @http_mock.should_receive(:get).and_return(response_mock)
        response_mock.should_receive(:body).and_return("") # so the method exits right after the setup
      end
      it { make_request }
    end

    context "handles a TimeoutError" do
      before do
        setup_http_mock
        @http_mock.should_receive(:get) { raise TimeoutError }
      end
      it { expect { make_request }.to raise_error(VideoSystemApi::VideoSystemApiException) }
    end

    context "handles general Exceptions" do
      before do
        setup_http_mock
        @http_mock.should_receive(:get) { raise Exception }
      end
      it { expect { make_request }.to raise_error(VideoSystemApi::VideoSystemApiException) }
    end

    context "returns an empty hash if the response body is empty" do
      before do
        setup_http_mock
        response_mock = mock()
        @http_mock.should_receive(:get).and_return(response_mock)
        response_mock.should_receive(:body).and_return("")
      end
      it { make_request.should == { } }
    end

    context "hashfies and validates the response body" do
      before do
        setup_http_mock
        response_mock = mock()
        @http_mock.should_receive(:get).and_return(response_mock)
        response_mock.should_receive(:body).twice.and_return("response-body")
      end

      context "checking if it has a :response key" do
        before { Hash.should_receive(:from_xml).with("response-body").and_return({ }) }
        it { expect { make_request }.to raise_error(VideoSystemApi::VideoSystemApiException) }
      end

      context "checking if it the :response key has a :returncode key" do
        before { Hash.should_receive(:from_xml).with("response-body").and_return({ :response => { } }) }
        it { expect { make_request }.to raise_error(VideoSystemApi::VideoSystemApiException) }
      end
    end

    context "formats the response hash" do
      let(:response) { { :response => { :returncode => true } } }
      let(:formatted_response) { { :returncode => true } }
      before do
        setup_http_mock

        response_mock = mock()
        @http_mock.should_receive(:get).and_return(response_mock)
        response_mock.should_receive(:body).twice.and_return("response-body")
        Hash.should_receive(:from_xml).with("response-body").and_return(response)

        # here starts the validation
        formatter_mock = mock(VideoSystemApi::VideoSystemApiFormatter)
        VideoSystemApi::VideoSystemApiFormatter.should_receive(:new).with(response).and_return(formatter_mock)
        formatter_mock.should_receive(:default_formatting).and_return(formatted_response)
      end
      it { make_request }
    end

    context "raise an error if the formatted response has no :returncode" do
      let(:response) { { :response => { :returncode => true } } }
      let(:formatted_response) { { } }
      before do
        setup_http_mock

        response_mock = mock()
        @http_mock.should_receive(:get).and_return(response_mock)
        response_mock.should_receive(:body).twice.and_return("response-body")
        Hash.should_receive(:from_xml).with("response-body").and_return(response)

        formatter_mock = mock(VideoSystemApi::VideoSystemApiFormatter)
        VideoSystemApi::VideoSystemApiFormatter.should_receive(:new).with(response).and_return(formatter_mock)
        formatter_mock.should_receive(:default_formatting).and_return(formatted_response)
      end
      it { expect { make_request }.to raise_error(VideoSystemApi::VideoSystemApiException) }
    end

  end

end
