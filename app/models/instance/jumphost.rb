class Instance::Jumphost < Instance

  belongs_to :context, polymorphic: true # context is a device

end
