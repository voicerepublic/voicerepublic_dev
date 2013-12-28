namespace :cleanup do

  desc 'Delete guest users that are no longer active'
  task :guests => :environment do
    User.where('firstname like ?', '%guest%').where('last_request_at < ?', 4.hours.ago).destroy_all
  end
end
