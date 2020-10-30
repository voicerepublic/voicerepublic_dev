class CreateInstances < ActiveRecord::Migration[6.0]
  def change
    create_table :instances do |t|
      t.string  :type
      t.string  :state
      t.string  :context_type
      t.integer :context_id
      t.string  :ec2_type
      t.string  :image
      t.string  :security_group
      t.string  :key_name
      t.string  :client_token
      t.string  :name
      t.string  :userdata_template_path
      t.text    :userdata
      t.string  :identifier
      t.string  :public_ip_address

      t.timestamps null: false
    end
  end
end
