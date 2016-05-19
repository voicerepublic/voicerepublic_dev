class ChangeAppearanceForSpeaker < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute("TRUNCATE appearances")
    rename_column :appearances, :user_id, :speaker_id
  end
end
