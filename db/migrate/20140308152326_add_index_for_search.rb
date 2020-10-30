class AddIndexForSearch < ActiveRecord::Migration[6.0]
  def change
    add_index :pg_search_documents, :content
  end
end


