require 'spec_helper'

describe ApplicationHelper do

  describe "youtubify" do
    it "should preserve identity" do
      txt = 'no links in here'
      helper.youtubify(txt).should == txt
    end

    it "should preserve identity on non-youtube links" do
      txt = "here is a http://unicodesnowmanforyou.com"
      helper.youtubify(txt).should == txt
    end

    it "work with ordinary links" do
      txt = 'check out http://www.youtube.com/watch?v=F0G0YNHINwY'
      helper.youtubify("hello #{txt} 123").should match('iframe')
    end

    it "work with short links" do
      txt = 'check out http://youtu.be/F0G0YNHINwY'
      helper.youtubify("hello #{txt} 123").should match('iframe')
    end

    it "work with multiple links" do
      txt = 'check out http://www.youtube.com/watch?v=F0G0YNHINwY or http://youtu.be/F0G0YNHINwY'
      helper.youtubify("hello #{txt} 123").should match('iframe')
    end
  end  

end
