require 'spec_helper'

describe Api::SocialSharesController do

  describe 'anonymous' do
    it 'does returns with unauthorized' do
      venue = FactoryGirl.create(:venue, user: @current_user)
      @talk = FactoryGirl.create(:talk, venue: venue)
      xhr :post, :create, id: @talk.id
      response.status.should be(401)
    end
  end

  describe 'logged in' do
    describe 'log share activity' do

      before do
        @current_user = FactoryGirl.create(:user)
        request.env['warden'].stub :authenticate! => @current_user
        controller.stub :current_or_guest_user => @current_user
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
          xhr :post, :create, social_share: { shareable_type: 'talk', shareable_id: @talk.id }
        }.to change(SocialShare, :count).by(1)

        share = SocialShare.last
        share.user_agent.should == "Rails Testing"
        share.request_ip.should == "0.0.0.0"
        share.user_id.should == @current_user.id
      end

      it 'returns json to verify success' do
        xhr :post, :create, social_share: { shareable_type: 'talk', shareable_id: @talk.id }
        res = JSON.parse(response.body)
        res['shareable_type'].should == 'talk'
        res['shareable_id'].should == @talk.id
        res['user_agent'].should == "Rails Testing"
        res['request_ip'].should == "0.0.0.0"
        res['user_id'].should == @current_user.id
      end

      it 'guards against random shares' do
        xhr :post, :create, social_share: { shareable_type: 'random' }
        res = JSON.parse(response.body)
        res['shareable_type'][0].should == "is not included in the list"
      end

    end
  end

end
