# -*- mode: ruby -*-
Vagrant.configure("2") do |config|
  config.vm.box = "puppetlabs/centos-7.0-64-nocm"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision :shell, :inline => <<-EOH
    if [ ! -f /usr/bin/puppet ]; then
      rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
      yum install -y puppet-server-3.8.4
    fi
  EOH

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "init.pp"
    puppet.module_path    = "modules"
  end
end
