require 'rails_helper'

# TODO cleanup, remove `venue_id: @venue.id`
describe TalksController do

  before do
    @user = FactoryGirl.create(:user)
    @venue = FactoryGirl.create(:venue, user: @user)
    @talk = FactoryGirl.create :talk, venue: @venue
    @user_2 = FactoryGirl.create :user
    @venue_2 = FactoryGirl.create :venue, user: @user_2
    @talk_2 = FactoryGirl.create :talk, venue: @venue_2
    allow(request.env['warden']).to receive_messages :authenticate! => @user
    allow(controller).to receive_messages :current_user => @user
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

  describe 'Talk#show' do
    describe 'assigns talks to @related_talks' do
      before do
        @other_venue_same_user = FactoryGirl.create :venue, user: @user
        @talk_other_venue = FactoryGirl.create :talk, :archived, :featured,
          venue_id: @other_venue_same_user.id
        other_venue_other_user = FactoryGirl.create :venue, user: @user_2
        @talk_other_user = FactoryGirl.create :talk, :archived, :featured, :popular,
          venue_id: other_venue_other_user.id
      end
      # first choice
      it 'assigns archived talks of series when available' do
        talk_same_venue = FactoryGirl.create :talk, :archived, :featured,
          venue_id: @venue.id

        get :show, { :id => @talk.id, :venue_id => @venue.id, :format => :text }
        expect(assigns(:related_talks)).not_to include(@talk)
        expect(assigns(:related_talks)).to include(talk_same_venue)
        expect(assigns(:related_talks)).not_to include(@talk_other_venue)
        expect(assigns(:related_talks)).not_to include(@talk_other_user)
      end

      # second choice
      it 'assigns archived talks of same user' do
        get :show, { :id => @talk.id, :venue_id => @venue.id, :format => :text }
        expect(assigns(:related_talks)).to include(@talk_other_venue)
        expect(assigns(:related_talks)).not_to include(@talk_other_user)
      end

      # third choice
      it 'assigns popular talks of any user' do
        @talk_other_venue.destroy
        get :show, { :id => @talk.id, :venue_id => @venue.id, :format => :text }
        expect(assigns(:related_talks)).not_to include(@talk_other_venue)
        expect(assigns(:related_talks)).to include(@talk_other_user)
      end
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
        expect(@talk.title).not_to eq('new test title')
        post :update, { venue_id: @venue.id, id: @talk.id, talk: { "title" => 'new test title' } }
        expect(@talk.reload.title).to eq('new test title')
      end
      it "does not update the talk" do
        expect {
          post :update, { venue_id: @venue_2.id, id: @talk_2.id, talk: { "title" => 'new test title' } }
        }.to raise_error(CanCan::AccessDenied)
        expect(@talk.reload.title).not_to eq('new test title')
      end
    end
  end


  describe "Talk#create" do
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
        attrs = FactoryGirl.attributes_for(:talk, venue_id: @venue_2.id)
        expect {
          post :create, { talk: attrs }
        }.to raise_error(CanCan::AccessDenied)
      end
    end

    it 'talk has attached tags after creation' do
      expect(Talk.count).to be(2) # @talk & @talk_2
      post :create, { venue_id: @venue.id, talk: valid_attributes }
      expect(assigns(:talk).venue_id).not_to be_nil
      expect(assigns(:talk).errors.to_a).to eq([])
      expect(Talk.all[2].tag_list).not_to be_empty
    end

    it 'creates a new venue on the fly' do
      attrs = FactoryGirl.attributes_for(:talk, venue_id: nil,
                                         new_venue_title: 'Some title')
      expect {
        post :create, talk: attrs
      }.to_not raise_error

      talk = assigns(:talk)
      expect(talk).to be_persisted
      expect(talk.venue).not_to be_nil
      expect(talk.venue).to be_persisted
    end
  end

  describe "download message history" do
    before do
      FactoryGirl.create :message, talk: @talk, content: "spec content"
    end

    describe "Authorization" do
      it 'downloads a talks message history' do
        get :show, { :id => @talk.id, :venue_id => @venue.id, :format => :text }
        expect(response.body).to include("spec content")
      end

      it 'authorizes downloading a talks message history' do
        expect {
          get :show, { :id => @talk_2.id, :venue_id => @venue_2.id, :format => :text }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

end
