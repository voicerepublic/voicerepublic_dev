class ChangeOfferIdFieldToKluIdInVideoSession < ActiveRecord::Migration
  def up
    remove_column :video_sessions, :offer_id
    add_column :video_sessions, :klu_id, :integer
  end

  def down
    add_column :video_sessions, :offer_id, :integer
    remove_column :video_sessions, :klu_id
  end
end
