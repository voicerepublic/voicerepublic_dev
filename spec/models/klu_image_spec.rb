require 'spec_helper'

describe KluImage do
  it "has a valid factory" do
    FactoryGirl.create(:klu_image).should be_valid
  end
  
  #it "is invalid without a kluuu" do
  #  FactoryGirl.build(:klu_image, :kluuu => nil).should_not be_valid
  #end
  
  it "has an image attached" do
    FactoryGirl.create(:klu_image).image.exists?.should be_true
  end
  
  it "will be destroyed if related kluuu is destroyed" do
    _ki = FactoryGirl.create(:klu_image)
    _ki.kluuu.destroy
    expect { KluImage.find(_ki.id) }.to raise_error
  end
end
