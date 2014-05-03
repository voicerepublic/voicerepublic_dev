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

  describe 'Talk#index' do
    it 'assigns recent talks as @talks_recent' do
      talk = FactoryGirl.create(:talk, state: :archived, featured_from: Date.today)
      get :index, {}
      assigns(:talks_recent).should eq([talk])
    end
  end

  describe "Talk#new" do
    it 'does not crash with too few inputs' do
      expect {
        post :create, { venue_id: @venue.id, talk: { title: "", starts_at_date: "" } }
      }.to_not raise_error

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
  end

  describe "download message history" do
    before do
      @user = FactoryGirl.create(:user)
      @venue.update_attribute :user, @user
      @talk = FactoryGirl.create :talk, venue: @venue
      FactoryGirl.create :message, talk: @talk, content: "spec content"
    end

    it 'downloads a talks message history' do
      current_user = @user
      request.env['warden'].stub :authenticate! => current_user
      controller.stub current_user: current_user
      current_user.reload

      get :show, { :id => @talk.id, :venue_id => @venue.id, :format => :text }
      response.body.should include("spec content")
    end

    it 'authorizes downloading a talks message history' do
      expect {
        get :show, { :id => @talk.id, :venue_id => @venue.id, :format => :text }
      }.to raise_error(CanCan::AccessDenied)
    end
  end

end
