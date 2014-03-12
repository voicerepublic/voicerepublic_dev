require 'spec_helper'

describe TalksController do

  before do
    @venue = FactoryGirl.create(:venue)
  end
  # This should return the minimal set of attributes required to create a valid
  # Talk. As you add validations to Talk, be sure to adjust the attributes here
  # as well.
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:talk) do |hash|
      hash[:venue_id] = @venue.id
    end
  end

  it 'allows for creation of a new talk' do
    expect {
      post :create, { venue_id: @venue.id, talk: valid_attributes }
    }.to change(Talk, :count).by(1)
  end

  it 'talk has attached tags after creation' do
    Talk.count.should be(0)
    post :create, { venue_id: @venue.id, talk: valid_attributes }
    Talk.last.tag_list.should_not be_empty
  end

  pending 'more specs'


end
