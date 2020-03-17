Vagrant.configure(2) do |config|
  config.vm.guest = :freebsd
  config.vm.boot_timeout = 600

  config.vm.box = "mcree/opnsense"
  config.vm.communicator = 'ssh'
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.ssh.sudo_command = "%c"
  config.ssh.shell = "/bin/sh"
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = 1024
    vb.cpus = 1
    vb.gui = false # no need for gui - shall be managed via web interface
    # enable promiscuous mode for work interfaces
    vb.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
    vb.customize ['modifyvm', :id, '--nicpromisc3', 'allow-all']
    vb.customize ['modifyvm', :id, '--nicpromisc4', 'allow-all']
  end

  config.vm.network :forwarded_port, guest: 443, host: 10443, auto_correct: true
  config.vm.network "private_network", adapter: 2, virtualbox__intnet: true, auto_config: false
  config.vm.network "private_network", adapter: 3, virtualbox__intnet: true, auto_config: false
  config.vm.network "private_network", adapter: 4, virtualbox__intnet: true, auto_config: false
end
