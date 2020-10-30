# encoding : utf-8

class ChangeEventTitle < ActiveRecord::Migration[6.0]
  def up
    # TODO this is bad
    # Event.where("events.title IS NULL OR events.title = ''").find_each do |event|
    #   event.update_column(:title, event.venue.title)
    # end

    change_column :events, :title, :string, :null => false
  end

  def down
    change_column :events, :title, :string, :null => true
  end
end
