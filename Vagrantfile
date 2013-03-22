# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.box = "precise64"
  config.vm.forward_port 80, 8080
  config.vm.share_folder("v-root", "/home/vagrant/{{ project_name }}", ".")
  config.vm.share_folder("s-root", "/srv/salt", "salt/salt")
  config.vm.share_folder("p-root", "/srv/pillar", "salt/pillar")

  ## Salt Provisioner (requires `vagrant gem install vagrant-salt`)
  config.vm.provision :salt do |salt|
    salt.run_highstate = true
    salt.salt_install_type = "git"
    salt.salt_install_args = "develop"
  end
end
