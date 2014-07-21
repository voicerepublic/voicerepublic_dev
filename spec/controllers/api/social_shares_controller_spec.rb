require 'spec_helper'

describe Api::SocialSharesController do

  describe 'anonymous' do
    it 'does not return with unauthorized' do
      @talk = FactoryGirl.create(:talk)
      xhr :post, :create, id: @talk.id, social_share: { asdf: 'asdf' }
      response.status.should_not be(401)
      response.status.should be(200)
    end
  end

  describe 'logged in' do
    describe 'log share activity' do

      before do
        @current_user = FactoryGirl.create(:user)
        request.env['warden'].stub :authenticate! => @current_user
        controller.stub current_user: @current_user
        @current_user.reload
        venue = FactoryGirl.create(:venue, user: @current_user)
        @talk = FactoryGirl.create(:talk, venue: venue)
      end

      it 'creates a social_share' do
        xhr :post, :create, social_share: { shareable_type: 'talk' }
        response.status.should be(200)
      end

      it 'tracks what was shared' do
        expect {
          xhr :post, :create, social_share: { shareable_type: 'talk',
                                              shareable_id: @talk.id,
                                              social_network: 'facebook' }
        }.to change(SocialShare, :count).by(1)

        share = SocialShare.last
        share.user_agent.should == "Rails Testing"
        share.request_ip.should == "0.0.0.0"
        share.user_id.should == @current_user.id
        share.social_network.should == 'facebook'
      end

      it 'returns json to verify success' do
        xhr :post, :create, social_share: { shareable_type: 'talk',
                                            shareable_id: @talk.id }
        res = JSON.parse(response.body)
        res['message'].should == I18n.t("social_share/has_been_tracked")
      end

      it 'guards against random shares' do
        xhr :post, :create, social_share: { shareable_type: 'random' }
        res = JSON.parse(response.body)
        res['message']['shareable_type'][0].should == "is not included in the list"
      end

    end
  end

end
