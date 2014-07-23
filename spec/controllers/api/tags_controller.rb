require 'spec_helper'

describe Api::TagsController do

  describe 'anonymous' do
    it 'returns tags' do
      10.times { FactoryGirl.create :tag }
      FactoryGirl.create :tag, name: "maunzbraunz"
      get :tags, q: 'maunz'
      response.status.should be(200)
      res = JSON.parse(response.body)
      JSON.parse(response.body)

      res['tags'].first['name'].should == 'maunzbraunz'
    end
  end

end
