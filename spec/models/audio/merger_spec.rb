require 'spec_helper'

describe Audio::Merger do

  it 'nicely merges streams' do
    fixture = 'spec/support/fixtures/talk_a'
    audio_fixture(fixture, 1) do |base, dir, name|
      Talk::Audio.new(base).journal

      Audio::Merger.run(base)

      size_0 = File.size("#{fixture}/#{name}.wav")
      size_1 = File.size("#{base}.wav")
      expect(size_1).to be(size_0)

      # FIXME this doesn't work presumably because of meta data
      #md5_0 = Digest::MD5.file("#{path}/#{name}.wav").hexdigest
      #md5_1 = Digest::MD5.file("#{dir}/#{name}.wav").hexdigest
      #expect(md5_1).to eq(md5_0)
    end
  end

  pending 'spec more intricate examples'

end
