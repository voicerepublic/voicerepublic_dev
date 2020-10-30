class AddListenersToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :listeners, :text, default: '--- {}'
  end
end
