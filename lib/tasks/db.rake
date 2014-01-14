namespace :db do
  namespace :sync do
    task :production do
      dump = "pgdump_production_2_#{ `hostname`.chomp }.sql"

      script = <<-SCRIPT
        rake db:drop db:create
        ssh rails@kluuu.com "pg_dump rails_production > #{ dump } && gzip #{ dump }"
        scp rails@kluuu.com:#{ dump }.gz .
        ssh rails@kluuu.com "rm #{ dump }.gz"
        gunzip #{ dump }.gz
        psql vr_development < #{ dump }
        rm #{ dump }*
      SCRIPT

      puts 'Sync production database...'
      system script
    end

    task :staging do
      dump = "pgdump_staging_2_#{ `hostname`.chomp }.sql"

      script = <<-SCRIPT
        rake db:drop db:create
        ssh rails@kluuu.com "pg_dump rails_staging > #{ dump } && gzip #{ dump }"
        scp rails@kluuu.com:#{ dump }.gz .
        ssh rails@kluuu.com "rm #{ dump }.gz"
        gunzip #{ dump }.gz
        psql vr_development < #{ dump }
        rm #{ dump }*
      SCRIPT

      puts 'Sync staging database...'
      system script
    end
  end

  namespace :data do
    desc 'Anonymize sensitive data'
    task :anonymize do
      query = <<-SQL
        UPDATE users
        SET email = CONCAT('test+user', id, '@kluuu.com');

        UPDATE users
        SET firstname = CONCAT('test_firstname+user', id);

        UPDATE users
        SET lastname = CONCAT('test_lastname+user', id);

      SQL

      puts 'Anonymize database...'
      system 'psql', 'vr_development', '-c', query
    end

    desc 'Validates all records in the database'
    task :validate => :environment do
      puts 'Validate database (this will take some time)...'

      Dir["#{Rails.root}/app/models/**/*.rb"].each { |f| require "#{ f }" }

      ActiveRecord::Base.subclasses.
        reject { |type| type.to_s.include? '::' }. # subclassed classes are not our own models
        each do |type|
          begin
            type.find_each do |record|
              unless record.valid?
                puts "#<#{ type } id: #{ record.id }, errors: #{ record.errors.full_messages }>"
              end
            end
          rescue Exception => e
            puts "An exception occurred: #{ e.message }"
          end
        end
    end
  end
end
