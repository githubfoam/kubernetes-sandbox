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
      k8scluster.vm.box = "bento/ubuntu-16.04"
      k8scluster.vm.hostname = "k8s-master"
      k8scluster.vm.network "private_network", ip: "192.168.50.10"
      k8scluster.vm.provider "virtualbox" do |vb|
          vb.name = "k8s-master"
          vb.memory = "1024"
      end
      k8scluster.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "provisioning/deploy.yml"
        ansible.become = true
        ansible.compatibility_mode = "2.0"
        ansible.version = "2.8.3"
        ansible.extra_vars = {
                node_ip: "192.168.50.10",
            }
      end
      k8scluster.vm.provision "shell", inline: <<-SHELL
            hostnamectl status
      SHELL
    end

    config.vm.define "node-1" do |k8scluster|
        k8scluster.vm.box = "bento/ubuntu-16.04"
        k8scluster.vm.hostname = "node-1"
        k8scluster.vm.network "private_network", ip: "192.168.50.11"
        k8scluster.vm.provider "virtualbox" do |vb|
            vb.name = "node-1"
            vb.memory = "768"
        end
        k8scluster.vm.provision "ansible_local" do |ansible|
          ansible.playbook = "provisioning/deploy.yml"
          ansible.become = true
          ansible.compatibility_mode = "2.0"
          ansible.version = "2.8.3"
          ansible.extra_vars = {
                  node_ip: "192.168.50.11",
              }
        end
        k8scluster.vm.provision "shell", inline: <<-SHELL
              hostnamectl status
        SHELL
      end


      config.vm.define "node-2" do |k8scluster|
          k8scluster.vm.box = "bento/ubuntu-16.04"
          k8scluster.vm.hostname = "node-2"
          k8scluster.vm.network "private_network", ip: "192.168.50.12"
          k8scluster.vm.provider "virtualbox" do |vb|
              vb.name = "node-2"
              vb.memory = "768"
          end
          k8scluster.vm.provision "ansible_local" do |ansible|
            ansible.playbook = "provisioning/deploy.yml"
            ansible.become = true
            ansible.compatibility_mode = "2.0"
            ansible.version = "2.8.3"
            ansible.extra_vars = {
                    node_ip: "192.168.50.12",
                }
          end
          k8scluster.vm.provision "shell", inline: <<-SHELL
                hostnamectl status
          SHELL
        end


end
