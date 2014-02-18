class AddAudioFormatsToTalk < ActiveRecord::Migration
  def change
    add_column :talks, :audio_formats, :text, default: [].to_yaml
  end
end
