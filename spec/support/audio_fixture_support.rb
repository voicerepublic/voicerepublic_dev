module AudioFixtureHelper
  def audio_fixture(path, glob='*')
    Dir.mktmpdir do |temp|
      FileUtils.cp(Dir.glob("#{path}/#{glob}"), temp)
      yield temp, Dir.glob("#{temp}/#{glob}")
    end
  end
end

RSpec.configure do |config|
  config.include AudioFixtureHelper, type: :model, type: :feature
end
