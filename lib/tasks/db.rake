namespace :db do

  # this extends the existing `db:create`
  desc 'setup psql extensions'
  task :create do
    config = Rails.configuration.database_configuration
    unless config[Rails.env]["adapter"] == 'postgresql'
      puts
      puts 'Not using a postgres db? We might have a problem here.'
      exit 1
    end

    puts 'setting up postgresql extensions'
    database = config[Rails.env]["database"]
    sql = <<-SQL
      CREATE EXTENSION pg_trgm;
      CREATE EXTENSION unaccent;
    SQL
    system 'psql', database, '-c', sql
  end

  namespace :sync do
    task :live do
      dump = "pgdump_production_2_#{ `hostname`.chomp }.sql"

      script = <<-SCRIPT
        rake db:drop db:create
        ssh app@voicerepublic.com "pg_dump rails_production > #{ dump } && gzip #{ dump }"
        scp app@voicerepublic.com:#{ dump }.gz .
        ssh app@voicerepublic.com "rm #{ dump }.gz"
        gunzip #{ dump }.gz
        psql #{Rails.configuration.database_configuration[Rails.env]["database"]} < #{ dump }
        rm #{ dump }*
      SCRIPT

      puts 'Sync production database...'
      system script
    end

    task :staging do
      dump = "pgdump_staging_2_#{ `hostname`.chomp }.sql"

      script = <<-SCRIPT
        rake db:drop db:create
        ssh app@staging.voicerepublic.com "pg_dump rails_production > #{ dump } && gzip #{ dump }"
        scp app@staging.voicerepublic.com:#{ dump }.gz .
        ssh app@staging.voicerepublic.com "rm #{ dump }.gz"
        gunzip #{ dump }.gz
        psql #{Rails.configuration.database_configuration[Rails.env]["database"]} < #{ dump }
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
  end
end
