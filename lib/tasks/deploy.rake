namespace :deploy do
  namespace :cleanup do
    task :clear_old_caches do
      current_path = File.expand_path(File.join(%w(.. .. current)), Dir.pwd)
      releases_path = File.expand_path('..', Dir.pwd)
      active_release_path = File.readlink(current_path)
      active_release_timestamp = File.basename(active_release_path)
      Dir.chdir(releases_path) do
        old_releases = Dir.glob('*') - [active_release_timestamp]
        old_releases.each do |old_release|
          FileUtils.rm_rf Dir.glob("#{old_release}/tmp/cache/*")
        end
      end
    end
  end
end
