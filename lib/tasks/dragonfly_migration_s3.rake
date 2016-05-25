# This will move all images and other Dragonfly assets from your local server file system to Amazon S3.

namespace :dragonfly do
  task migrate_to_s3: :environment do
    logfile_path = Rails.root.join('public/system/dragonfly', Rails.env, 'images_local_to_s3.txt')
    logfile = {}
    File.open(logfile_path, 'r') {|file| logfile = Hash[file.readlogfile.map { |e| e.split(" => ")}] } if File.file?(logfile_path)
    begin
      # Adjust this line to meet your needs:
      { Series => :image_uid, Talk => :image_uid, User => [:header_uid, :avatar_uid] }.each do |klass, col|
        puts "Migrating #{klass.table_name}..."
        Array(col).each do |col|
          klass.where("#{col} != ''").find_each do |instance|
            begin
                old_uid = instance.send(col)
                puts "Migrating #{old_uid}..."
                if logfile.value? old_uid
                  puts "Already migrated!"
                  next
                end
                old_path = Rails.root.join('public/system/dragonfly', Rails.env, old_uid)
                if File.file?(old_path)
                  new_uid = Dragonfly.app.store old_path
                  instance.update_attributes col => new_uid
                  logfile[old_uid] = new_uid
                  # We might want to keep the local images for the moment, just in case.
                  # If we want to delete them, we can do so like this:
                  #FileUtils.rm_f old_path
                  #FileUtils.rm_f "#{old_path}.meta.yml"
                  puts 'Done'
                else
                  logfile[old_uid] = "FILE_MISSING"
                  puts 'File missing'
                end
              rescue => e
                puts "Failed: #{e.message}"
              end
          end
        end
      end
    ensure
      File.open(logfile_path, 'w') {|file| logfile.each {|old_uid, new_uid| file.puts "#{old_uid} => #{new_uid}"} }
    end
  end
end
