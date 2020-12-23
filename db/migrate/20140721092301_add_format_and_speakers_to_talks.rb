class AddFormatAndSpeakersToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :format, :string
    add_column :talks, :speakers, :string
  end
end
