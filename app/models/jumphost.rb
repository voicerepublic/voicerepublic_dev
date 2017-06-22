class Jumphost < ActiveRecord::Base

  belongs_to :device, as: :context

  def default_client_token
    [ device.identifier[0, 64-16], Time.now.to_i, generate_password(4) ] * '-'
  end

  def default_name
    [ device.name, generate_password(4) ] * '-'
  end

end
