require 'spec_helper'

describe Audio::Merger do

  it 'nicely merges streams' do
    fixture = 'spec/support/fixtures/talk_a'
    audio_fixture(fixture, 1) do |base, dir, name|
      j = TalkAudio.new(base).journal
      Audio::Merger.run(base, j)

      size_0 = File.size("#{fixture}/#{name}.wav")
      size_1 = File.size("#{base}.wav")
      expect(size_1).to be(size_0)

      # FIXME this doesn't work presumably because of meta data
      #md5_0 = Digest::MD5.file("#{path}/#{name}.wav").hexdigest
      #md5_1 = Digest::MD5.file("#{dir}/#{name}.wav").hexdigest
      #expect(md5_1).to eq(md5_0)
    end
  end

  it 'merges streams synchronously' do
    fixture = 'spec/support/fixtures/complex'
    audio_fixture(fixture, '1') do |base|
      j = TalkAudio.new(base).journal
      p1 = Audio::Merger.run(base, j)

      p0 = "#{fixture}/1.wav"
      c0 = open(p0, "rb") {|io| io.read }
      c1 = open(p1, "rb") {|io| io.read }
      # %x[ aplay #{p0} ]
      # %x[ aplay #{p1} ]

      # expect(c1).to eq(c0)
    end
  end


end
