require 'rails_helper'

# TODO cleanup, remove `series_id: @series.id`
describe TalksController do

  before do
    @user = FactoryGirl.create(:user)
    @series = FactoryGirl.create(:series, user: @user)
    @venue = FactoryGirl.create(:venue, user: @user)
    @talk = FactoryGirl.create :talk, series: @series
    @user_2 = FactoryGirl.create :user
    @series_2 = FactoryGirl.create :series, user: @user_2
    @talk_2 = FactoryGirl.create :talk, series: @series_2
  end
  # This should return the minimal set of attributes required to create a valid
  # Talk. As you add validations to Talk, be sure to adjust the attributes here
  # as well.
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:talk) do |hash|
      hash[:series_id] = @series.id
      hash[:venue_id] = @venue.id
    end
  end

  describe 'Unauthenticated' do
    describe 'Talk#new' do
      it 'raises an error for Talk#new' do
        get :new
        expect(response).to be_a_redirect
      end
    end
  end

  describe 'Authenticated' do
    before do
      allow(request.env['warden']).to receive_messages :authenticate! => @user
      allow(controller).to receive_messages current_user: @user
      @user.reload
    end

    describe 'Talk#show' do
      describe 'assigns talks to @related_talks' do
        before do
          @other_series_same_user = FactoryGirl.create :series, user: @user
          @talk_other_series = FactoryGirl.create :talk, :archived, :featured,
            series_id: @other_series_same_user.id
          other_series_other_user = FactoryGirl.create :series, user: @user_2
          @talk_other_user = FactoryGirl.create :talk, :archived, :featured, :popular,
            series_id: other_series_other_user.id
        end

        pending 'TODO logic changed, move to unit tests and fix'
        # # first choice
        # it 'assigns archived talks of series when available' do
        #   talk_same_series = FactoryGirl.create :talk, :archived, :featured,
        #     series_id: @series.id
        #
        #   get :show, id: @talk.id
        #   ids = assigns(:related_talks).map(&:id)
        #
        #   expect(ids).not_to include(@talk.id)
        #   expect(ids).to include(talk_same_series.id)
        #   expect(ids).not_to include(@talk_other_series.id)
        #   expect(ids).not_to include(@talk_other_user.id)
        # end
        #
        # # second choice
        # it 'assigns archived talks of same user' do
        #   get :show, id: @talk.id
        #   ids = assigns(:related_talks).map(&:id)
        #   expect(ids).to include(@talk_other_series.id)
        #   expect(ids).not_to include(@talk_other_user.id)
        # end

        # third choice
        it 'assigns popular talks of any user' do
          @talk_other_series.destroy
          get :show, id: @talk.id
          ids = assigns(:related_talks).map(&:id)
          expect(ids).not_to include(@talk_other_series.id)
          expect(ids).to include(@talk_other_user.id)
        end
      end
    end

    describe "Talk#new" do
      it 'responds if credits available' do
        get 'new'
        expect(response).to be_a_success
      end
      # NOTE everhting is for free ATM
      # it 'redirects if out of credits' do
      #   @user.update_attribute(:credits, 0)
      #   get 'new'
      #   expect(response).to be_a_redirect
      # end
    end

    describe "Talk#destroy" do
      describe "Authorization" do
        it 'destroys the talk' do
          expect {
            delete :destroy, {series_id: @series.id, id: @talk.to_param}
          }.to change(Talk, :count).by(-1)
        end
        it 'does not destroy the talk' do
          delete :destroy, {series_id: @series_2.id, id: @talk_2.to_param}
          expect(response.status).to eq(403)
        end
      end
    end

    describe "Talk#update" do
      describe "Authorization" do
        it "updates the talk" do
          expect(@talk.title).not_to eq('new test title')
          post :update, { series_id: @series.id, id: @talk.id,
                          talk: { "title" => 'new test title' } }
          expect(@talk.reload.title).to eq('new test title')
        end
        it "does not update the talk" do
          post :update, { series_id: @series_2.id, id: @talk_2.id,
                          talk: { "title" => 'new test title' } }
          expect(response.status).to eq(403)
          expect(@talk.reload.title).not_to eq('new test title')
        end
      end
    end


    describe "Talk#create" do
      it 'does not crash with too few inputs' do
        expect {
          post :create, talk: { series_id: @series.id, title: "", starts_at_date: "" }
        }.to_not raise_error
      end
      describe "Authorization" do
        it 'allows for creation of a new talk' do
          expect {
            post :create, { series_id: @series.id, talk: valid_attributes }
          }.to change(Talk, :count).by(1)
        end
        it 'does not allow for creation of a new talk' do
          attrs = FactoryGirl.attributes_for(:talk, series_id: @series_2.id)
          post :create, { talk: attrs }
          expect(response.status).to eq(403)
        end
      end

      it 'talk has attached tags after creation' do
        expect(Talk.count).to be(2) # @talk & @talk_2
        post :create, talk: valid_attributes
        expect(assigns(:talk).series_id).not_to be_nil
        expect(assigns(:talk).errors.to_a).to eq([])
        expect(Talk.all[2].tag_list).not_to be_empty
      end

      it 'creates a new series and new venues on the fly' do
        attrs = FactoryGirl.attributes_for(:talk,
                                           series_id: nil,
                                           new_series_title: 'Some title',
                                           venue_id: nil,
                                           new_venue_name: 'Some name')
        expect {
          post :create, talk: attrs
        }.to_not raise_error

        talk = assigns(:talk)
        expect(talk).to be_persisted
        expect(talk.series).not_to be_nil
        expect(talk.series).to be_persisted
      end
    end

    describe "download message history" do
      before do
        FactoryGirl.create :message, talk: @talk, content: "spec content"
      end

      describe "Authorization" do
        it 'downloads a talks message history' do
          get :show, id: @talk.id, series_id: @series.id, format: :text
          expect(response.body).to include("spec content")
        end

        it 'authorizes downloading a talks message history' do
          get :show, id: @talk_2.id, series_id: @series_2.id, format: :text
          expect(response.status).to eq(403)
        end
      end
    end

  end

end
