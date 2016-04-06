# This will move all images and other Dragonfly assets from your local server file system to Amazon S3.

namespace :dragonfly do
  task migrate_to_s3: :environment do

    Rails.root.join('public/system/dragonfly', Rails.env, 'images_local_to_s3.txt'), 'r') do |file|
      lines = Hash[file.readlines.map { |e| e.split(" => ")}]
    end
    # Adjust this line to meet your needs:
    { Series => :image_uid, Talk => :image_uid, User => [:header_uid, :avatar_uid] }.each do |klass, col|
      puts "Migrating #{klass.table_name}..."
      Array(col).each do |col|
        klass.where("#{col} != ''").find_each do |instance|
          begin
              old_uid = instance.send(col)
              puts "Migrating #{old_uid}..."
              old_path = Rails.root.join('public/system/dragonfly', Rails.env, old_uid)
              if File.exist?(old_path) && !lines.include? old_uid
                new_uid = Dragonfly.app.store old_path
                instance.update_attributes col => new_uid
                lines[old_path] = old_uid
                #FileUtils.rm_f old_path
                #FileUtils.rm_f "#{old_path}.meta.yml"
                puts 'Done'
              else
                puts 'Already migrated'
              end
            rescue => e
              puts "Failed: #{e.message}"
            end
        end
      end
    end
    File.open(Rails.root.join('public/system/dragonfly', Rails.env, 'images_local_to_s3.txt'), 'w+') do |file|
      li
    end
  end
end
