class AddFormatAndSpeakersToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :format, :string
    add_column :talks, :speakers, :string
  end
end
