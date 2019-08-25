# -*- mode: ruby -*-
# vi: set ft=ruby :


# Vagrant version and Vagrant API version requirements
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# YAML module for reading box configurations.
require 'yaml'

#  server configs from YAML/YML file
servers_list = YAML.load_file(File.join(File.dirname(__FILE__), 'servers_list.yml'))

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 # Disable updates
 config.vm.box_check_update = false

      servers_list.each do |server|
        config.vm.define server["vagrant_box_host"] do |box|
          box.vm.box = server["vagrant_box"]
          box.vm.hostname = server["vagrant_box_host"]
          box.vm.network server["network_type"], ip: server["ip"]

          if server["guest_port1"] and server["host_port1"] != nil
            box.vm.network "forwarded_port", guest: server["guest_port1"], host: server["host_port1"]
            box.vm.network "forwarded_port", guest: server["guest_port2"], host: server["host_port2"]
            box.vm.network "forwarded_port", guest: server["guest_port3"], host: server["host_port3"]
          end

          box.vm.provider "virtualbox" do |vb|
              vb.name = server["vbox_name"]
              vb.memory = server["vbox_ram"]
              vb.cpus = server["vbox_cpu"]
              vb.gui = false
              vb.customize ["modifyvm", :id, "--groups", "/k8s-multimaster-grp"] # create vbox group
          end # end of box.vm.providers


          if server["server_bootstrap"] != nil
              box.vm.provision "ansible_local" do |ansible|
                  ansible.compatibility_mode = "2.0"
                  ansible.version = server["ansible_version"]
                  ansible.playbook = server["server_bootstrap"]
                  ansible.inventory_path = 'inventory'
                  # ansible.inventory_path = 'provisioning/hosts'
                  # ansible.verbose = "vvvv" # debug
              end # end if box.vm.provision
          end  # end if server["server_bootstrap"]

          # run for all computes
          box.vm.provision "shell", inline: <<-SHELL
                hostnamectl status
          SHELL

          if server["server_script"] != nil
              box.vm.provision :shell, :path => server["server_script"]
          end # end if server["server_cript"]


        end # end of config.vm
      end  # end of servers_list.each loop
end # end of Vagrant.configure
