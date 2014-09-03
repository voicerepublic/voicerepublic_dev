class AddAudioUploadToTalk < ActiveRecord::Migration
  def change
    add_column :talks, :audio_upload_uid,  :string
    add_column :talks, :audio_upload_name, :string
  end
end
