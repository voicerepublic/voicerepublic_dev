require 'rails_helper'

describe FactoryGirl do

  exceptions = [:participant_basis, :series]

  it "should have a valid factory for Series" do
    expect(FactoryGirl.create('series')).to be_valid
  end

  FactoryGirl.factories.each do |factory|
    unless exceptions.include?(factory.name)
      it "should have a valid factory for #{factory.name}" do
        expect(FactoryGirl.build(factory.name)).to be_valid
      end
    end
  end
end
