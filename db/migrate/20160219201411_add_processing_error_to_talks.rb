class AddProcessingErrorToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :processing_error, :text
  end
end
