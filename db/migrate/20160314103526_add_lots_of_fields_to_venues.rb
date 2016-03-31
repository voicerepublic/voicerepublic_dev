class AddLotsOfFieldsToVenues < ActiveRecord::Migration
  def change

    # string ephemeral
    add_column :venues, :client_token, :string, index: true
    add_column :venues, :instance_id, :string
    add_column :venues, :public_ip_address, :string
    add_column :venues, :stream_url, :string
    add_column :venues, :mount_point, :string
    add_column :venues, :source_password, :string
    add_column :venues, :admin_password, :string

    # string non-ephemeral
    add_column :venues, :state, :string
    add_column :venues, :instance_type, :string
    add_column :venues, :source_identifier, :string
    add_column :venues, :source_ip_address, :string
    add_column :venues, :emergency_phone_number, :string

    # text
    add_column :venues, :street_address, :text

    # integer
    add_column :venues, :estimated_number_of_listeners, :integer

    # datetime ephemaral
    add_column :venues, :started_provisioning_at, :datetime
    add_column :venues, :completed_provisioning_at, :datetime

  end
end
