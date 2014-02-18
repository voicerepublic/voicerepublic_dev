require 'spec_helper'

describe Audio::Transcoder do

  it 'nicly transcodes wav files' do
    path, name = 'spec/support/fixtures/transcode0', 1
    Dir.mktmpdir do |dir|
      FileUtils.cp(Dir.glob("#{path}/*.wav"), dir)
      Audio::Transcoder.run("#{dir}/#{name}")
      size_0 = File.size("#{path}/#{name}.m4a")
      size_1 = File.size("#{dir}/#{name}.m4a")
      expect(size_1).to be(size_0)
    end
  end

end
