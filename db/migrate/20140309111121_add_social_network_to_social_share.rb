class AddSocialNetworkToSocialShare < ActiveRecord::Migration
  def change
    add_column :social_shares, :social_network, :string
  end
end
