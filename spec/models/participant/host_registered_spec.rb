require 'spec_helper'

describe Participant::HostRegistered do
  it "has a valid host participant factory" do
    FactoryGirl.create(:host_participant).should be_valid
  end
end
