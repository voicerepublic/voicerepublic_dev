class AddAudioFormatsToTalk < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :audio_formats, :text, default: [].to_yaml
  end
end
