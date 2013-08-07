require 'spec_helper'

describe Article do

  it "should hav a valid factory" do
    build(:article).should be_valid
  end

end
