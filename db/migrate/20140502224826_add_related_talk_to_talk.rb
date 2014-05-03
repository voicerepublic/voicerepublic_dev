class AddRelatedTalkToTalk < ActiveRecord::Migration
  def change
    add_column :talks, :related_talk_id, :integer
  end
end
