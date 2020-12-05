class ChangeDefaultOfStorage < ActiveRecord::Migration[6.0]
  def change
    change_column :talks, :storage, :text, default: "--- {}\n"
  end
end
