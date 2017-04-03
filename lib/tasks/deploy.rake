namespace :deploy do
  namespace :cleanup do
    task :clear_old_caches do
      current_path = Rails.root.join('..', '..', 'current')
      releases_path = Rails.root.join('..')
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
