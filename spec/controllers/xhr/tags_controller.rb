require 'spec_helper'

describe Xhr::TagsController do

  describe 'anonymous' do
    it 'returns tags' do
      10.times { FactoryGirl.create :tag }
      FactoryGirl.create :tag, name: "maunzbraunz"
      get :index, q: 'maunz'
      expect(response.status).to be(200)
      res = JSON.parse(response.body)

      expect(res['tags'].first['name']).to eq('maunzbraunz')
    end
  end

end
