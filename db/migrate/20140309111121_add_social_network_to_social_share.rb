class AddSocialNetworkToSocialShare < ActiveRecord::Migration[6.0]
  def change
    add_column :social_shares, :social_network, :string
  end
end
