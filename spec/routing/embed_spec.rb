# coding: utf-8
require 'rails_helper'

describe 'routes for embeds' do
  describe 'legacy' do

    it 'does not route /embed_talk/:id anymore' do
      expect(get: '/embed_talk/slug').not_to be_routable
    end

    it 'does route /embed/:id (oldschool)' do
      expect(get: '/embed/slug').to be_routable
    end

    it 'does route /embed/talks/:id (newschool)' do
      expect(get: '/embed/talks/slug').to be_routable
    end

    it 'does route /embed/series/:id' do
      expect(get: '/embed/series/slug').to be_routable
    end

  end
end
