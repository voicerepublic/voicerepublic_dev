require 'spec_helper'

describe FactoryGirl do
  FactoryGirl.factories.each do |factory|
    it "should have a valid factory for #{factory.name}" do
      expect(FactoryGirl.build(factory.name)).to be_valid
    end
  end
end



