require 'rails_helper'

RSpec.describe Venue, type: :model do

  describe 'validates' do
    it 'presence of name' do
      talk = FactoryGirl.build(:venue)
      talk.name = nil
      expect(talk).to be_invalid
    end

    it 'presence of user' do
      talk = FactoryGirl.build(:venue)
      talk.user = nil
      expect(talk).to be_invalid
    end
  end

  describe 'friendly id' do
    it 'has a slug' do
      talk = FactoryGirl.create(:venue)
      expect(talk.slug).to be_present
    end

    it 'uses the id and name if name is taken' do
      talk0 = FactoryGirl.create(:venue, name: 'hello')
      expect(talk0.slug).to eq('hello')
      talk1 = FactoryGirl.create(:venue, name: 'hello')
      expect(talk1.slug).to match(/\Ahello-[a-f\d\-]+\z/)
    end
  end

  describe 'options' do
    it 'deserialized' do
      talk = FactoryGirl.build(:venue)
      expect(talk.options).to be_a(Hash)
    end

    it 'provide a handy shortcut' do
      talk = FactoryGirl.build(:venue, options: { bla: 'blub' } )
      expect(talk.opts.bla).to eq('blub')
    end
  end

end
