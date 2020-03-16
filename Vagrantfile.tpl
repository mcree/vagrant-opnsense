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
    vb.gui = false # no need for gui
    # since opnsense expects nic1 (first) to be LAN, lets make it intnet
    # nic2 is wan, so we are doing nat ( routed to the host )
    vb.customize ['modifyvm', :id, '--nic1', 'intnet', '--nic2', 'intnet', '--nic3', 'intnet', '--nic4', 'nat']
    # we forward the ports to the WebGUI/ssh since we use a nat network
    #vb.customize ['modifyvm', :id, '--natpf4', "ssh,tcp,127.0.0.1,2222,,22" ] #port forward
    #vb.customize ['modifyvm', :id, '--natpf4', "https,tcp,127.0.0.1,10443,,443" ] #port forward
  end

  #config.vm.network "private_network", virtualbox__intnet: true, auto_config: false
  #config.vm.network "private_network", virtualbox__intnet: true, auto_config: false
  #config.vm.network "private_network", virtualbox__intnet: true, auto_config: false
  #config.vm.network :forwarded_port, guest: 22, host: 10022, auto_correct: true
  #config.vm.network :forwarded_port, guest: 443, host: 10443, auto_correct: true
end
