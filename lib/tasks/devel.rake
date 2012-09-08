namespace :devel do
  
  desc "creates rspec -fh output of all specs"
  task :generate_rspec_documentation  do
    Dir.chdir Rails.root do 
      exec "bundle exec rspec -fh > #{File.join(Rails.root,'doc', 'index.html')}"
    end
  end
  
end