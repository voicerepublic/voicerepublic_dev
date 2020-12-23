class AddStartsAtFieldsToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :starts_at_date, :string
    add_column :talks, :starts_at_time, :string

    execute "UPDATE talks SET starts_at_date=TO_CHAR(starts_at, 'YYYY-MM-DD');"
    execute "UPDATE talks SET starts_at_time=TO_CHAR(starts_at, 'HH24:MI');"
  end
end
