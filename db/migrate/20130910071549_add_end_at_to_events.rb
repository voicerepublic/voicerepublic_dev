class AddEndAtToEvents < ActiveRecord::Migration[6.0]
  def up
    add_column :events, :end_at, :datetime

    # TODO really bad
    # Event.reset_column_information
    # past = Event.where("events.start_time + events.duration * interval '1 minute' <= ?", Time.now.in_time_zone)
    # past.find_each do |event|
    #   event.update_column(:end_at, event.start_time.in_time_zone + event.duration.minutes)
    # end
  end

  def down
    remove_column :events, :end_at
  end
end
