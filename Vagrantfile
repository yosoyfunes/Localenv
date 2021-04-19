# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # https://app.vagrantup.com/hashicorp/boxes/bionic64
  config.vm.box = "hashicorp/bionic64"

  config.vm.box_check_update = true

  # Forwarded port mapping: 8502 -> 8502 for exposed service
  config.vm.network "forwarded_port", guest: 8502, host: 8502
  # Forwarded port mapping: 8503 -> 8503 for kubernetes dasboard
  config.vm.network "forwarded_port", guest: 8503, host: 8503
  # Forwarded port mapping: 5000 -> 5000 for Docker Registry
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  # Forwarded port mapping: 8088 -> 80 for Ingress-Controller
  config.vm.network "forwarded_port", guest: 80, host: 8088
  config.vm.network "forwarded_port", guest: 443, host: 8443 

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.15",  :mount_options => ["dmode=755,fmode=755"]

  # Share an additional folder to the guest VM
  config.vm.synced_folder "../", "/vagrant_data"

  # Customize the disk size on the guest VM: (using vagrant-disksize plugin)
  # config.disksize.size = '50GB' 

  # Customize hostname of the guestVM 
  config.vm.hostname = "k3d-tf-cluster"

  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the guest VM:
    vb.memory = "2048"
  end

  # Enable provisioning guest VM with shell script
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update -y

    # Install Docker
    # Reference: https://docs.docker.com/engine/install/ubuntu/
    apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-registry unzip  python3.7 python-pip

    # Install k3d
    # Reference: https://github.com/rancher/k3d
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v3.1.5 bash

    # Install kubectl
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    mv kubectl /usr/local/bin/
    chmod +x /usr/local/bin/kubectl

    # Install Terraform 0.12.29
    wget -q https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip
    sudo unzip ./terraform_0.13.0_linux_amd64.zip -d /usr/local/bin/
    
    # Install AWS Cli
    sudo pip install aws-shell
    mkdir /vagrant/secret/
    mkdir /root/.aws/
    ln -s /vagrant/secret/aws_credentials /root/.aws/credentials

    # Install Helm3
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh

    # Add vagrant user to docker group (Running docker command without sudo)
    addgroup -a vagrant docker

  SHELL
end
