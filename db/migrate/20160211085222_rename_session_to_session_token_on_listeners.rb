class RenameSessionToSessionTokenOnListeners < ActiveRecord::Migration
  def change
    rename_column :listeners, :session, :session_token
  end
end
