class RemovePages < ActiveRecord::Migration[6.0]
  def change
    drop_table :pages
  end
end
