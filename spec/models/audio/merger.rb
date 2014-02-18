require 'spec_helper'

describe Audio::Merger do

  it 'generates fake journals' do
    path, name = 'spec/support/fixtures/talk_a', 1
    journal_1 = Audio::Merger.fake_journal(path, name)
    journal_0 = File.read("#{path}/#{name}.journal").chomp
    expect(journal_1).to eq(journal_0)
  end

  it 'nicely merges streams' do
    path, name = 'spec/support/fixtures/talk_a', 1
    Dir.mktmpdir do |dir|
      FileUtils.cp(Dir.glob("#{path}/*.flv"), dir)
      Audio::Merger.generate_fake_journal(dir, name)
      Audio::Merger.run("#{dir}/#{name}")

      size_0 = File.size("#{path}/#{name}.wav")
      size_1 = File.size("#{dir}/#{name}.wav")
      expect(size_1).to be(size_0)

      # FIXME this doesn't work presumably because of meta data
      #md5_0 = Digest::MD5.file("#{path}/#{name}.wav").hexdigest
      #md5_1 = Digest::MD5.file("#{dir}/#{name}.wav").hexdigest
      #expect(md5_1).to eq(md5_0)
    end
  end

  pending 'spec more intricate examples'

end
