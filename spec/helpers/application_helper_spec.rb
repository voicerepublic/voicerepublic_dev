require 'rails_helper'

describe ApplicationHelper do

  describe "youtubify" do
    it "should preserve identity" do
      txt = 'no links in here'
      expect(helper.youtubify(txt)).to eq(txt)
    end

    it "should preserve identity on non-youtube links" do
      txt = "here is a http://unicodesnowmanforyou.com"
      expect(helper.youtubify(txt)).to eq(txt)
    end

    it "work with ordinary links" do
      txt = 'check out http://www.youtube.com/watch?v=mjunK37tOG4'
      expect(helper.youtubify("hello #{txt} 123")).to match('iframe')
    end

    it "work with short links" do
      txt = 'check out http://youtu.be/mjunK37tOG4'
      expect(helper.youtubify("hello #{txt} 123")).to match('iframe')
    end

    it "work with multiple links" do
      txt = 'check out http://www.youtube.com/watch?v=mjunK37tOG4 or http://youtu.be/mjunK37tOG4'
      expect(helper.youtubify("hello #{txt} 123")).to match('iframe')
    end

    #     it 'works nicely' do
    #       txt = <<-EOF
    # some text here
    # http://kluuu.com
    # more text
    # and a video http://www.youtube.com/watch?v=mjunK37tOG4
    # finishing text here
    #       EOF
    #       expected = <<-EOF
    # <p>some text here
    # <br /><a href='http://kluuu.com' target='_blank'>http://kluuu.com</a>
    # <br />more text
    # <br />and a video <a href='http://www.youtube.com/watch?v=mjunK37tOG4' target='_blank'>http://www.youtube.com/watch?v=mjunK37tOG4</a>
    # <br />finishing text here</p>
    #
    # <p><iframe width='307' height='188' src='//www.youtube.com/embed/mjunK37tOG4'' frameborder='0' allowfullscreen></iframe></p>
    #       EOF
    #       helper.sophisticated_format(txt).should eq(expected.chomp)
    #     end
  end

end
