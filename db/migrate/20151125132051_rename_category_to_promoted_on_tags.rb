class RenameCategoryToPromotedOnTags < ActiveRecord::Migration[6.0]
  def change
    rename_column :tags, :category, :promoted
  end
end
