class ChangeDefaultOfStorage < ActiveRecord::Migration
  def change
    change_column :talks, :storage, :text, default: "--- {}\n"
  end
end
