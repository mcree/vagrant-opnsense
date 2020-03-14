Vagrant.configure(2) do |config|
  config.vm.guest = :freebsd
  config.vm.boot_timeout = 600

  config.vm.communicator = 'ssh'

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = 1024
    vb.cpus = 1
  end

  config.vm.network :forwarded_port, guest: 22, host: 10022, auto_correct: true
  config.vm.network :forwarded_port, guest: 443, host: 10443, auto_correct: true
  config.vm.network "private_network", virtualbox__intnet: true, auto_config: false
end
