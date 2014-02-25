module AudioFixtureHelper
  def audio_fixture(path, name)
    Dir.mktmpdir do |dir|
      FileUtils.cp(Dir.glob("#{path}/*.flv"), dir)
      yield "#{dir}/#{name}", dir, name
    end
  end
end

RSpec.configure do |config|
  config.include AudioFixtureHelper, type: :model
end
