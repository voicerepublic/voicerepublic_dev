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
      puts <<-EOF

        IMPORTANT!

        Please make sure you have no other process running which might
        have a connection to the database.

      EOF

      dump = "pgdump_production_2_#{ `hostname`.chomp }.sql"
      database = Rails.configuration.database_configuration[Rails.env]["database"]
      host = 'app@voicerepublic.com'

      puts 'Sync production database...'
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke
      sh "ssh #{host} "+
         "'pg_dump rails_production > #{ dump } && gzip #{ dump }'"
      sh "scp #{host}:#{ dump }.gz ."
      sh "ssh #{host} 'rm #{ dump }.gz'"
      sh "gunzip #{ dump }.gz"
      sh "psql #{database} < #{ dump }"
      sh "rm #{ dump }*"

      puts 'Sync production images... (This might take a while.)'
      source = 'app/shared/public/system/dragonfly/production/'
      target = 'public/system/dragonfly/development/'
      sh "rsync -az --progress #{host}:#{source} #{target}"
    end

    # TODO make this task use db:sync:live with another host set
    task :staging do
      puts 'Please resolve the TODO before runnning this task.'
      exit

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
      # TODO fix db name
      system 'psql', 'vr_development', '-c', query
    end
  end
end
