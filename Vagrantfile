# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.box = "precise64"
  config.vm.network :forwarded_port, host: 8080, guest: 80
  config.vm.synced_folder ".", "/home/vagrant/{{ project_name }}"
  config.vm.synced_folder "salt/salt", "/srv/salt"
  config.vm.synced_folder "salt/pillar", "/srv/pillar"

  ## Salt Provisioner (requires `vagrant gem install vagrant-salt`)
  config.vm.provision :salt do |salt|
    salt.run_highstate = true
    salt.salt_install_type = "git"
    salt.salt_install_args = "develop"
  end
end
