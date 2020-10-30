class InstallContribPackages < ActiveRecord::Migration[6.0]
  def up
    #execute "CREATE EXTENSION pg_trgm;"
    #execute "CREATE EXTENSION unaccent;"
    ## execute "CREATE EXTENSION fuzzystrmatch;"
  end

  def down
    #execute "DROP EXTENSION pg_trgm;"
    #execute "DROP EXTENSION unaccent;"
    ## execute "DROP EXTENSION fuzzystrmatch;"
  end
end
