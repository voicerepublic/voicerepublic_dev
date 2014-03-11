class AddIndexForSearch < ActiveRecord::Migration
  def change
    add_index :pg_search_documents, :content
  end
end


