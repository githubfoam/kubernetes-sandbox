# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "512"
    vb.cpus = 2 # not less than the required 2
  end

  config.vm.define "k8s-master" do |k8scluster|
      k8scluster.vm.box = "bento/centos-7.6"
      k8scluster.vm.hostname = "k8s-master"
      k8scluster.vm.network "private_network", ip: "10.0.15.10"
      k8scluster.vm.provider "virtualbox" do |vb|
          vb.name = "k8s-master"
          vb.memory = "2048"
      end
      k8scluster.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "provisioning/deploymaster.yml"
        ansible.become = true
        ansible.compatibility_mode = "2.0"
        ansible.version = "2.8.2"
        ansible.extra_vars = {
                node_ip: "10.0.15.10",
            }
      end
      k8scluster.vm.provision "shell", inline: <<-SHELL
            hostnamectl status
      SHELL
    end

    config.vm.define "node01" do |k8scluster|
        k8scluster.vm.box = "bento/centos-7.4"
        k8scluster.vm.hostname = "node01"
        k8scluster.vm.network "private_network", ip: "10.0.15.21"
        k8scluster.vm.provider "virtualbox" do |vb|
            vb.name = "node01"
            vb.memory = "2048"
        end
        k8scluster.vm.provision "ansible_local" do |ansible|
          ansible.become = true
          ansible.compatibility_mode = "2.0"
          ansible.version = "2.8.2"
          ansible.extra_vars = {
                  node_ip: "10.0.15.21",
              }
          ansible.playbook = "provisioning/deploynode01.yml"
        end
        k8scluster.vm.provision "shell", inline: <<-SHELL
              hostnamectl status
        SHELL
      end


      config.vm.define "node02" do |k8scluster|
          k8scluster.vm.box = "bento/ubuntu-19.04"
          k8scluster.vm.hostname = "node02"
          k8scluster.vm.network "private_network", ip: "10.0.15.22"
          k8scluster.vm.provider "virtualbox" do |vb|
              vb.name = "node02"
              vb.memory = "1024"
          end
          k8scluster.vm.provision "ansible_local" do |ansible|
            # https://www.vagrantup.com/docs/provisioning/ansible_common.html Shared Ansible Options
            ansible.become = true
            ansible.compatibility_mode = "2.0"
            ansible.version = "2.8.3" # ubuntu-19.04
            ansible.extra_vars = {
                    node_ip: "10.0.15.22"
                }
            ansible.playbook = "provisioning/deploynode02_ubuntu.yml"
          end
          k8scluster.vm.provision "shell", inline: <<-SHELL
                hostnamectl status
          SHELL
        end


end
