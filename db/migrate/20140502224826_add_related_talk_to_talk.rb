class AddRelatedTalkToTalk < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :related_talk_id, :integer
  end
end
