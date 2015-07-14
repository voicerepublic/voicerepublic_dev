require 'rails_helper'

describe Redcarpet do

  describe "youtubify" do
    before do
      @vrhtml = Redcarpet::Render::VRHTML.new
      # set public for specs
      @vrhtml.class.send :public, :youtubify
    end

    it "should preserve identity" do
      txt = 'no links in here'
      expect(@vrhtml.youtubify(txt)).to eq(txt)
    end

    it "should preserve identity on non-youtube links" do
      txt = "here is a http://unicodesnowmanforyou.com"
      expect(@vrhtml.youtubify(txt)).to eq(txt)
    end

    it "work with ordinary links" do
      txt = 'hello check out http://www.youtube.com/watch?v=mjunK37tOG4 123'
      expect(@vrhtml.youtubify(txt)).to match('iframe')
    end

    it "work with short links" do
      txt = 'hello check out http://youtu.be/mjunK37tOG4 123'
      expect(@vrhtml.youtubify(txt)).to match('iframe')
    end

    it "work with multiple links" do
      txt = 'hello check out http://www.youtube.com/watch?v=mjunK37tOG4 ' +
            'or http://youtu.be/mjunK37tOG4 123'
      expect(@vrhtml.youtubify(txt)).to match('iframe')
    end
  end

end
