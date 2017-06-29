class Instance < ActiveRecord::Base

  include PasswordGenerator
  include ActiveModel::Transitions

  state_machine auto_scopes: true do
    state :created
    state :pending, enter: :provision
    state :running, leave: :unprovision
    state :terminated

    event :launch do
      transitions from: :created, to: :pending, on_transition: :prepare
    end
    event :complete do
      transitions from: :pending, to: :running
    end
    event :terminate do
      transitions from: :running, to: :terminated
    end
  end

  private

  # stm callbacks

  def set_default(*fields)
    fields.each do field
      self.send("#{field}||=", send("default_#{field}"))
      raise "Field #{field} not set and doesn't have a default." if
        send(field.to_s).nil?
    end
  end

  def prepare
    set_default(:ec2_type,
                :security_group,
                :image,
                :key_name,
                :client_token,
                :userdata_template,
                :name,
                :userdata)
  end

  def provisioning_parameters
    [ image,
      1, # min
      1, # max
      { "InstanceType"  => ec2_type,
        "SecurityGroup" => security_group,
        "KeyName"       => key_name,
        "ClientToken"   => client_token,
        "UserData"      => userdata } ]
  end

  def provision
    response = EC2.run_instances(*provisioning_parameters)
    self.identifier = response.body["instancesSet"].first["instanceId"]
    EC2.tags.create(resource_id: identifier, key: 'Name', value: name)
    EC2.tags.create(resource_id: identifier, key: 'Target', value: Settings.target)
  end

  def unprovision
    instance = EC2.servers.get(instance_id)
    instance.destroy unless instance.nil?
  end

  # defaults

  def default_ec2_type
    Settings.instance[base_class_name].try(:ec2_type) ||
      Settings.instance.default.try(:ec2_type)
  end

  def default_security_group
    Settings.instance[base_class_name].try(:security_group) ||
      Settings.instance.default.try(:security_group)
  end

  def default_image
    Settings.instance[base_class_name].try(:security_group) ||
      Settings.instance.default.try(:security_group)
  end

  def default_key_name
    Settings.instance[base_class_name].try(:security_group) ||
      Settings.instance.default.try(:security_group)
  end

  def default_client_token
    raise 'needs to be implemented in subclass'
  end

  def default_name
    raise 'needs to be implemented in subclass'
  end

  def default_userdata_template
    rel = File.join(%w(lib templates), "#{base_class_name}.sh.erb")
    File.expand_path(rel, Rails.root)
  end

  def default_userdata
    raise "Template not found: #{userdata_template}" unless
      File.exist?(userdata_template)
    ERB.new(File.read(userdata_template)).result(binding)
  end

  # helpers

  def base_class_name
    self.class.name.underscore.split('/').last
  end

end
