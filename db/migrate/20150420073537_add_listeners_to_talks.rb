class AddListenersToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :listeners, :text, default: '--- {}'
  end
end
