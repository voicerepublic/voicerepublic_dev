class Instance::Jumphost < Instance

  belongs_to :context, polymorphic: true # context is a device

  def default_client_token
    [ 'jh', device.identifier[0, 64-16], Time.now.to_i, generate_password(4) ] * '-'
  end

  def default_name
    [ 'jh', device.name, generate_password(4) ] * '-'
  end

end
