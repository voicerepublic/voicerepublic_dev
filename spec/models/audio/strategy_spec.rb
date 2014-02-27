require 'spec_helper'

describe Audio::Strategy do

  it 'prepares (running the precursor)' do
    audio_fixture('spec/support/fixtures/complex', '*.flv') do |path|
      setting = TalkSetting.new(path)
      results = Audio::Strategy::Precursor.call(setting)
      all_exist = results.inject(true) { |r, f| r && File.exist?(f) }
      expect(all_exist).to be_true
    end
  end

  # it 'merges' do
  #   audio_fixture('spec/support/fixtures/normalize0', 1) do |base|
  #     #opts = { path: }
  #     #Audio::Strategy::KluuuMerge.call(opts)
  #     #audio = TalkAudio.new(base)
  #     #result = audio.merge!
  #     #expect(File.exist?(result)).to be_true
  #   end
  # end
  # 
  # it 'trims' do
  #   audio_fixture('spec/support/fixtures/normalize0', 1) do |base|
  #     # audio = TalkAudio.new(base)
  #     # audio.merge!
  #     # 
  #     # audio_start = audio.journal['record_done'].first.last.to_i
  #     # talk_start = audio_start + 3 # 3s later
  #     # talk_stop = audio_start + 6 # 6s later
  #     # result = audio.trim!(talk_start, talk_stop)
  #     # cmd = "soxi -D #{result}"
  #     # duration = %x[ #{cmd} ].to_f.round
  #     # expect(duration).to eq(3)
  #   end
  # end
  # 
  # it 'transcodes' do
  #   audio_fixture('spec/support/fixtures/normalize0', 1) do |base|
  #     # audio = TalkAudio.new(base)
  #     # audio.merge!
  #     # result = audio.transcode!
  #     # expect(File.exist?(result)).to be_true
  #   end
  # end
  # 
  # it 'nicely merges streams' do
  #   fixture = 'spec/support/fixtures/talk_a'
  #   audio_fixture(fixture, 1) do |base, dir, name|
  #     # j = TalkAudio.new(base).journal
  #     # Audio::Merger.run(base, j)
  #     # 
  #     # size_0 = File.size("#{fixture}/#{name}.wav")
  #     # size_1 = File.size("#{base}.wav")
  #     # expect(size_1).to be(size_0)
  #     # 
  #     # # FIXME this doesn't work presumably because of meta data
  #     # #md5_0 = Digest::MD5.file("#{path}/#{name}.wav").hexdigest
  #     # #md5_1 = Digest::MD5.file("#{dir}/#{name}.wav").hexdigest
  #     # #expect(md5_1).to eq(md5_0)
  #   end
  # end
  # 
  # it 'merges streams synchronously' do
  #   fixture = 'spec/support/fixtures/complex'
  #   audio_fixture(fixture, '1') do |base|
  #     # j = TalkAudio.new(base).journal
  #     # p1 = Audio::Merger.run(base, j)
  #     # 
  #     # p0 = "#{fixture}/1.wav"
  #     # c0 = open(p0, "rb") {|io| io.read }
  #     # c1 = open(p1, "rb") {|io| io.read }
  #     # # %x[ aplay #{p0} ]
  #     # # %x[ aplay #{p1} ]
  #     # 
  #     # # expect(c1).to eq(c0)
  #   end
  # end
  # 
  # it 'nicly transcodes wav files' do
  #   # path, name = 'spec/support/fixtures/transcode0', 1
  #   # Dir.mktmpdir do |dir|
  #   #   FileUtils.cp(Dir.glob("#{path}/*.wav"), dir)
  #   #   Audio::Transcoder.run("#{dir}/#{name}")
  #   #   size_0 = File.size("#{path}/#{name}.m4a")
  #   #   size_1 = File.size("#{dir}/#{name}.m4a")
  #   #   expect(size_1).to be(size_0)
  #   # end
  # end

end
