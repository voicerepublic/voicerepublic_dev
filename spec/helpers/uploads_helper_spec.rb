require 'rails_helper'

describe UploadsHelper do

  let(:helper) { Class.new { include UploadsHelper }.new }

  #audio
  it 'has a method init_audio_uploader' do
    expect(helper).to respond_to(:init_audio_uploader)
  end

  it 'init_audio_uploader return a string' do
    expect(helper.init_audio_uploader).to be_a(String)
  end

  it 'init_audio_uploaders return value contains a url' do
    expect(helper.init_audio_uploader).to match(/http:\/\//)
  end

  it 'init_audio_uploaders return value contains an ampersand' do
    expect(helper.init_audio_uploader).to match(/http:\/\//)
  end

  # slides
  it 'has a method init_slides_uploader' do
    expect(helper).to respond_to(:init_slides_uploader)
  end

  it 'init_slides_uploader return a string' do
    expect(helper.init_slides_uploader).to be_a(String)
  end

  it 'init_slides_uploaders return value contains a url' do
    expect(helper.init_slides_uploader).to match(/http:\/\//)
  end

  it 'init_slides_uploaders return value contains an ampersand' do
    expect(helper.init_slides_uploader).to match(/http:\/\//)
  end

end
