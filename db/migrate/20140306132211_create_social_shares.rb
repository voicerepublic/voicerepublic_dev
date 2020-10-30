class CreateSocialShares < ActiveRecord::Migration[6.0]
  def change
    create_table :social_shares do |t|
      t.belongs_to :shareable, polymorphic: true

      t.string :request_ip
      t.string :user_agent
      t.integer :user_id

      t.timestamps
    end

    add_index :social_shares, [:shareable_id, :shareable_type]
  end
end
