class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :type
      t.string :state
      t.string :context_type
      t.string :context_id
      t.text :details
      t.datetime :started_at
      t.datetime :finished_at
      t.string :locked_by

      t.timestamps null: false
    end
  end
end
