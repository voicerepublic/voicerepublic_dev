class RemoveObsoleteAttributes < ActiveRecord::Migration[6.0]
  def up
    remove_column :venues, :intro_video
    remove_column :venues, :host_kluuu_id
  end

  def down
    add_column :venues, :intro_video, :string
  end
end
