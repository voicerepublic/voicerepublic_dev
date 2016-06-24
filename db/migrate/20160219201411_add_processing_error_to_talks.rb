class AddProcessingErrorToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :processing_error, :text
  end
end
