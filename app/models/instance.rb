class Instance < ActiveRecord::Base

  state_machine auto_scopes: true do
    state :prospecting
    state :provisioning, enter: :provision
    state :running
    state :terminated

    event :launch do
      transitions from: :prospecting, to: :pending, on_transition: :prepare
    end
    event :completed_launching do
      transitions from: :pending, to: :running
    end
    event :terminate do
      transitions from: :running, to: :terminated
    end
  end

  private

  def set_default(*fields)
    self.send(field.to_s + '||=', send('default_' + field.to_s))
    raise "Field #{field} not set and doesn't have a default." if send(field.to_s).nil?
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

  def default_ec2_type
    Settings.instance[self.class.name.underscore].try(:ec2_type) ||
      Settings.instance.default.try(:ec2_type)
  end

  def default_security_group
    Settings.instance[self.class.name.underscore].try(:security_group) ||
      Settings.instance.default.try(:security_group)
  end

  def default_image
    Settings.instance[self.class.name.underscore].try(:security_group) ||
      Settings.instance.default.try(:security_group)
  end

  def default_key_name
    Settings.instance[self.class.name.underscore].try(:security_group) ||
      Settings.instance.default.try(:security_group)
  end

  def default_client_token
    raise 'not implemented'
  end

  def default_name
    raise 'not implemented'
  end

  def default_userdata_template
    File.expand_path(File.join(%w(lib templates), self.class.name.underscore + '.sh.erb'), Rails.root)
  end

  def generate_userdata
    raise "Template not found: #{userdata_template}" unless File.exist?(userdata_template)
    ERB.new(File.read(userdata_template)).result(binding)
  end

end
