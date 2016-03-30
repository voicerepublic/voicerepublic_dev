require 'rails_helper'

describe Flyer do

  before do
    # unmocks the mocks in spec_helper
    allow_any_instance_of(Flyer).to receive(:generate!).and_call_original
    allow_any_instance_of(Flyer).to receive(:path).and_call_original
  end

  describe 'regeneration' do
    before do
      talk = FactoryGirl.create :talk, starts_at: Time.now
      @flyer = talk.flyer
    end
    after do
      # cleanup
      @flyer.disintegrate!
    end
    describe 'scope user' do
      it 'regenerates the flyer when updating the users name' do
        mtime_before = File.mtime(@flyer.path(fs=true))
        user = @flyer.talk.series.user.update_attribute :firstname, 'foo'
        expect(File.mtime(@flyer.path(fs=true))).to be > mtime_before
      end
    end

    describe 'scope talk' do
      it 'regenerates the flyer when updating the talks title' do
        mtime_before = File.mtime(@flyer.path(fs=true))
        @flyer.talk.update_attribute :title, 'foo'
        expect(File.mtime(@flyer.path(fs=true))).to be > mtime_before
      end
    end

  end

  describe 'in general' do
    before do
      talk = FactoryGirl.create(:talk, starts_at: Time.now)
      @flyer = Flyer.new(talk)
    end
    after do
      # cleanup
      @flyer.disintegrate!
    end

    it 'generates a file' do
      @flyer.generate!
      expect(@flyer).to exist
    end

    it 'replaces all interpolations' do
      svg = @flyer.svg_file.open.read
      expect(svg.match(/\[-[^-]+-\]/)).to be_nil
    end

    it 'uses all interpolations' do
      svg = File.read(@flyer.svg_template)
      @flyer.interpolations.each do |key, value|
        expect(svg).to include("[-#{key}-]")
      end
    end

    it 'provides a parsable template' do
      xml = File.read(@flyer.svg_template)
      doc =  Nokogiri::XML(xml)
      expect(doc.errors).to be_empty
    end

    it 'generates a png' do
      @flyer.generate!
      ident = %x[ identify #{@flyer.path(true)} ]
      expect(ident).to include('PNG')
    end
  end

end
