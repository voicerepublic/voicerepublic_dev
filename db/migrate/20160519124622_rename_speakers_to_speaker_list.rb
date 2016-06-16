class RenameSpeakersToSpeakerList < ActiveRecord::Migration
  def change
    rename_column :talks, :speakers, :speaker_list
  end
end
