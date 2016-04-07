class RenameListenersToListenersLegacyOnTalks < ActiveRecord::Migration
  def change

    rename_column :talks, :listeners, :listeners_legacy

  end
end
