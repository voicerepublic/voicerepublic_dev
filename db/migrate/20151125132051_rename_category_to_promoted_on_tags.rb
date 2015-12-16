class RenameCategoryToPromotedOnTags < ActiveRecord::Migration
  def change
    rename_column :tags, :category, :promoted
  end
end
