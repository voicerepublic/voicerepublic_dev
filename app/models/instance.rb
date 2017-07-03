class Instance < ActiveRecord::Base

  EPHEMERAL_FIELDS = [
    :ec2_type,
    :security_group,
    :image,
    :key_name,
    :client_token,
    :userdata_template_path,
    :name,
    :userdata
  ]

  include PasswordGenerator
  include ActiveModel::Transitions

  attr_accessor :event

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
    event :reset do # only to be used for debugging
      transitions from: [:pending, :running, :terminated],
                  to: :created, on_transition: :on_reset
    end
  end

  private

  # stm callbacks

  def on_reset
    EPHEMERAL_FIELDS.each do |field|
      send("#{field}=", nil)
    end
  end

  def set_default(*fields)
    fields.each do |field|
      self.send("#{field}=", send("default_#{field}")) if send(field).nil?
      raise "Field #{field} not set and doesn't have a default." if
        send(field).nil?
    end
  end

  def prepare
    set_default(*EPHEMERAL_FIELDS)
  end

  def provisioning_parameters
    [ image,
      1, # min
      1, # max
      { 'InstanceType'                      => ec2_type,
        'SecurityGroup'                     => security_group,
        'KeyName'                           => key_name,
        'ClientToken'                       => client_token,
        'UserData'                          => userdata,
        'InstanceInitiatedShutdownBehavior' => 'terminate' } ]
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
    Settings.instance[base_class_name].try(:image) ||
      Settings.instance.default.try(:image)
  end

  def default_key_name
    Settings.instance[base_class_name].try(:key_name) ||
      Settings.instance.default.try(:key_name)
  end

  def default_client_token
    [base_class_name, generate_password(4), Time.now.to_i] * '-'
  end

  def default_name
    [base_class_name, generate_password(4)] * '-'
  end

  def default_userdata_template_path
    rel = File.join(%w(lib templates), "#{base_class_name}.sh.erb")
    File.expand_path(rel, Rails.root)
  end

  def default_userdata
    ERB.new(userdata_template).result(binding)
  end

  # helpers

  def userdata_template
    raise "Template not found: #{userdata_template_path}" unless
      File.exist?(userdata_template_path)
    File.read(userdata_template_path)
  end

  def base_class_name
    self.class.name.underscore.split('/').last
  end

  def instance_endpoint
    Settings.instance.endpoint
  end

end
