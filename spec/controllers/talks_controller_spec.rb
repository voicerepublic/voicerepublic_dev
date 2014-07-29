require 'spec_helper'

describe TalksController do

  before do
    @user = FactoryGirl.create(:user)
    @venue = FactoryGirl.create(:venue, user: @user)
    @talk = FactoryGirl.create :talk, venue: @venue
    @user_2 = FactoryGirl.create :user
    @venue_2 = FactoryGirl.create :venue, user: @user_2
    @talk_2 = FactoryGirl.create :talk, venue: @venue_2
    request.env['warden'].stub :authenticate! => @user
    controller.stub :current_user => @user
    @user.reload
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

  describe "Talk#destroy" do
    describe "Authorization" do
      it 'destroys the talk' do
        expect {
          delete :destroy, {:venue_id => @venue.id, :id => @talk.to_param}
        }.to change(Talk, :count).by(-1)
      end
      it 'does not destroy the talk' do
        expect {
          delete :destroy, {:venue_id => @venue_2.id, :id => @talk_2.to_param}
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe "Talk#update" do
    describe "Authorization" do
      it "updates the talk" do
        @talk.title.should_not == 'new test title'
        post :update, { venue_id: @venue.id, id: @talk.id, talk: { "title" => 'new test title' } }
        @talk.reload.title.should == 'new test title'
      end
      it "does not update the talk" do
        expect {
          post :update, { venue_id: @venue_2.id, id: @talk_2.id, talk: { "title" => 'new test title' } }
        }.to raise_error(CanCan::AccessDenied)
        @talk.reload.title.should_not == 'new test title'
      end
    end
  end


  describe "Talk#new" do
    it 'does not crash with too few inputs' do
      expect {
        post :create, { venue_id: @venue.id, talk: { title: "", starts_at_date: "" } }
      }.to_not raise_error

    end
    describe "Authorization" do
      it 'allows for creation of a new talk' do
        expect {
          post :create, { venue_id: @venue.id, talk: valid_attributes }
        }.to change(Talk, :count).by(1)
      end
      it 'does not allow for creation of a new talk' do
        expect {
          post :create, { venue_id: @venue_2.id, talk: valid_attributes }
        }.to raise_error(CanCan::AccessDenied)
      end
    end

    it 'talk has attached tags after creation' do
      Talk.count.should be(2) # @talk & @talk_2
      post :create, { venue_id: @venue.id, talk: valid_attributes }
      Talk.all[2].tag_list.should_not be_empty
    end

    it 'talk has attached format after creation' do
      Talk.count.should be(2) # @talk & @talk_2
      post :create, { venue_id: @venue.id, talk: valid_attributes.merge(format: "foo_conf") }
      Talk.all[2].format.should == "foo_conf"
    end
  end

  describe "download message history" do
    before do
      FactoryGirl.create :message, talk: @talk, content: "spec content"
    end

    describe "Authorization" do
      it 'downloads a talks message history' do
        get :show, { :id => @talk.id, :venue_id => @venue.id, :format => :text }
        response.body.should include("spec content")
      end

      it 'authorizes downloading a talks message history' do
        expect {
          get :show, { :id => @talk_2.id, :venue_id => @venue_2.id, :format => :text }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

end
