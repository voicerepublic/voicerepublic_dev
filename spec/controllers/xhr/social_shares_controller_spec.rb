require 'rails_helper'

describe Xhr::SocialSharesController do

  describe 'anonymous' do
    it 'does not return with unauthorized' do
      @talk = FactoryGirl.create(:talk)
      xhr :post, :create, id: @talk.id, social_share: { asdf: 'asdf' }
      expect(response.status).not_to be(401)
      expect(response.status).to be(200)
    end
  end

  describe 'logged in' do
    describe 'log share activity' do

      before do
        @current_user = FactoryGirl.create(:user)
        allow(request.env['warden']).to receive_messages :authenticate! => @current_user
        allow(controller).to receive_messages current_user: @current_user
        @current_user.reload
        series = FactoryGirl.create(:series, user: @current_user)
        @talk = FactoryGirl.create(:talk, series: series)
      end

      it 'creates a social_share' do
        xhr :post, :create, social_share: { shareable_type: 'talk' }
        expect(response.status).to be(200)
      end

      it 'tracks what was shared' do
        expect {
          xhr :post, :create, social_share: { shareable_type: 'talk',
                                              shareable_id: @talk.id,
                                              social_network: 'facebook' }
        }.to change(SocialShare, :count).by(1)

        share = SocialShare.last
        expect(share.user_agent).to eq("Rails Testing")
        expect(share.request_ip).to eq("0.0.0.0")
        expect(share.user_id).to eq(@current_user.id)
        expect(share.social_network).to eq('facebook')
      end

      it 'returns json to verify success' do
        xhr :post, :create, social_share: { shareable_type: 'talk',
                                            shareable_id: @talk.id }
        res = JSON.parse(response.body)
        expect(res['message']).to eq(I18n.t("social_share/has_been_tracked"))
      end

      it 'guards against random shares' do
        xhr :post, :create, social_share: { shareable_type: 'random' }
        res = JSON.parse(response.body)
        expect(res['message']['shareable_type'][0]).to eq("is not included in the list")
      end

    end
  end

end
