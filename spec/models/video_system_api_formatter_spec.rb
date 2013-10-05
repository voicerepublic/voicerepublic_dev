#require 'video_system_api/video_system_api'
require 'date'

describe VideoSystemApi::VideoSystemApiFormatter do

  # describe "#hash" do
  #   subject { VideoSystemApi::VideoSystemApiFormatter.new({}) }
  #   it { subject.should respond_to(:hash) }
  #   it { subject.should respond_to(:"hash=") }
  # end
  # 
  # describe "#to_stringtring" do
  #   let(:hash) { { :param1 => "123", :param2 => 123, :param3 => true } }
  #   subject { VideoSystemApi::VideoSystemApiFormatter.new(hash) }
  #   it { subject.to_string(:param1).should == "123" }
  #   it { subject.to_string(:param2).should == "123" }
  #   it { subject.to_string(:param3).should == "true" }
  # end
  # 
  # describe "#to_booleanoolean" do
  #   let(:hash) { { :true1 => "TRUE", :true2 => "true", :false1 => "FALSE", :false2 => "false" } }
  #   subject { VideoSystemApi::VideoSystemApiFormatter.new(hash) }
  #   it { subject.to_boolean(:true1).should be_true }
  #   it { subject.to_boolean(:true2).should be_true }
  #   it { subject.to_boolean(:false1).should be_false }
  #   it { subject.to_boolean(:false2).should be_false }
  # end
  # 
  # describe "#to_datetime" do
  #   ts1 = DateTime.parse("Thu Sep 01 17:51:42 UTC 2011").to_time.to_i
  #   ts2 = DateTime.parse("Thu Sep 08").to_time.to_i
  #   let(:hash) { { :param1 => ts1, :param2 => ts2, :param3 => "NULL" } }
  #   subject { VideoSystemApi::VideoSystemApiFormatter.new(hash) }
  #   it { subject.to_datetime(:param1).should == DateTime.parse("Thu Sep 01 17:51:42 UTC 2011").to_time }
  #   it { subject.to_datetime(:param2).should == DateTime.parse("Thu Sep 08").to_time }
  #   it { subject.to_datetime(:param3).should == nil }
  # end
  # 
  # describe "#default_formatting" do
  #   let(:input) { { :response => { :returncode => "SUCCESS", :messageKey => "mkey", :message => "m" } } }
  #   let(:formatter) { VideoSystemApi::VideoSystemApiFormatter.new(input) }
  # 
  #   context "standard case" do
  #     let(:expected_output) { { :returncode => true, :messageKey => "mkey", :message => "m" } }
  #     subject { formatter.default_formatting }
  #     it { subject.should == expected_output }
  #   end
  # 
  #   context "when :returncode should be false" do
  #     before { input[:response][:returncode] = "ERROR" }
  #     subject { formatter.default_formatting }
  #     it { subject[:returncode].should be_false }
  #   end
  # 
  #   context "when :messageKey is empty" do
  #     before { input[:response][:messageKey] = {} }
  #     subject { formatter.default_formatting }
  #     it { subject[:messageKey].should == "" }
  #   end
  # 
  #   context "when :messageKey is nil" do
  #     before { input[:response].delete(:messageKey) }
  #     subject { formatter.default_formatting }
  #     it { subject[:messageKey].should == "" }
  #   end
  # 
  #   context "when :message is empty" do
  #     before { input[:response][:message] = {} }
  #     subject { formatter.default_formatting }
  #     it { subject[:message].should == "" }
  #   end
  # 
  #   context "when there's no :message key" do
  #     before { input[:response].delete(:message) }
  #     subject { formatter.default_formatting }
  #     it { subject[:message].should == "" }
  #   end
  # end
  # 
  # describe "#format_meeting" do
  #   let(:formatter) { VideoSystemApi::VideoSystemApiFormatter.new({}) }
  #   let(:hash) {
  #     { :meetingID => 123, :moderatorPW => 111, :attendeePW => 222,
  #       :hasBeenForciblyEnded => "FALSE", :running => "TRUE" }
  #   }
  # 
  #   subject { formatter.format_meeting(hash) }
  #   it { subject[:meetingID].should == "123" }
  #   it { subject[:moderatorPW].should == "111" }
  #   it { subject[:attendeePW].should == "222" }
  #   it { subject[:hasBeenForciblyEnded].should == false }
  #   it { subject[:running].should == true }
  # end
  # 
  # describe "#format_attendee" do
  #   let(:formatter) { VideoSystemApi::VideoSystemApiFormatter.new({}) }
  #   let(:hash) { { :userID => 123, :fullName => "Cameron", :role => "VIEWER" } }
  # 
  #   subject { formatter.format_attendee(hash) }
  #   it { subject[:userID].should == "123" }
  #   it { subject[:fullName].should == "Cameron" }
  #   it { subject[:role].should == :viewer }
  # end
  # 
  # describe "#flatten_objects" do
  #   let(:formatter) { VideoSystemApi::VideoSystemApiFormatter.new({ }) }
  # 
  #   context "standard case" do
  #     context "when the target key is empty" do
  #       let(:hash) { { :objects => {} } }
  #       before { formatter.hash = hash }
  #       subject { formatter.flatten_objects(:objects, :object) }
  #       it { subject.should == { :objects => [] } }
  #     end
  # 
  #     context "when there's only one object in the list" do
  #       let(:object_hash) { { :id => 1 } }
  #       let(:hash) { { :objects => { :object => object_hash } } }
  #       before { formatter.hash = hash }
  #       subject { formatter.flatten_objects(:objects, :object) }
  #       it { subject.should == { :objects => [ object_hash ] } }
  #     end
  # 
  #     context "when there are several objects in the list" do
  #       let(:object_hash1) { { :id => 1 } }
  #       let(:object_hash2) { { :id => 2 } }
  #       let(:hash) { { :objects => { :object => [ object_hash1, object_hash2 ] } } }
  #       before { formatter.hash = hash }
  #       subject { formatter.flatten_objects(:objects, :object) }
  #       it { subject.should == { :objects => [ object_hash1, object_hash2 ] } }
  #     end
  #   end
  # 
  #   context "using different keys" do
  #     let(:hash1) { { :any => 1 } }
  #     let(:hash2) { { :any => 2 } }
  #     let(:collection_hash) { { :foos => { :bar => [ hash1, hash2 ] } } }
  #     before { formatter.hash = collection_hash }
  #     subject { formatter.flatten_objects(:foos, :bar) }
  #     it { subject.should == { :foos => [ hash1, hash2 ] } }
  #   end
  # 
  # end


end
