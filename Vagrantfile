# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The '2' in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = 'debian/jessie64'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.
  #config.vm.network 'forwarded_port', guest: 3000, host: 3000
  #config.vm.network 'forwarded_port', guest: 3001, host: 3001
  #config.vm.network 'forwarded_port', guest:   22, host: 2222

  config.ssh.forward_agent = true

  # config.ssh.username = 'vagrant'
  # config.ssh.password = 'vagrant'
  config.ssh.insert_key = 'true'

  # config.ssh.private_key_path = '~/.ssh/id_rsa'

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network 'private_network', ip: '192.168.33.10'

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  config.vm.network 'public_network', bridge: 'wlan0: WiFi'

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder '../data', '/vagrant_data'

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
    #
    #   Customize the amount of memory on the VM:
    vb.memory = 1024 * 6

    # Utilize 100% of real CPU for the configured Cores
    # Note: This is probably the default
    vb.customize ['modifyvm', :id, '--cpuexecutioncap', '100']

    vb.cpus = 4
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define 'atlas' do |push|
  #   push.app = 'YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME'
  # end

  # The shell is set explicitly to not show an error which is not an
  # error (see discussion
  # https://github.com/mitchellh/vagrant/issues/1673#issuecomment-28288042)
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  # NOTE: Provisioning is only run on the _first_ call to `vagrant up`
  #       If you want to run it later, use `vagrant provision`

  config.vm.provision 'shell' do |s|
    ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
    s.inline = <<-SHELL
      echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
      sudo mkdir /root/.ssh
      sudo echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
    SHELL
  end

  # copy provision script
  config.vm.provision 'file', source: 'provision.sh', destination: 'provision.sh'
  # run provision script
  config.vm.provision 'shell', inline: 'sudo bash provision.sh'

end
