#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt-get update -y

# Install dependencies
echo "Installing dependencies..."
sudo apt-get install -y curl wget apt-transport-https software-properties-common

# Add Vagrant's official repository
echo "Adding Vagrant repository..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
sudo apt-add-repository "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Update the package list again
echo "Updating package list again..."
sudo apt-get update -y

# Install Vagrant
echo "Installing Vagrant..."
sudo apt-get install -y vagrant

# Verify Vagrant installation
echo "Verifying Vagrant installation..."
vagrant --version

# Install VirtualBox (required for Vagrant)
echo "Installing VirtualBox..."
sudo apt-get install -y virtualbox virtualbox-ext-pack

# Verify VirtualBox installation
echo "Verifying VirtualBox installation..."
virtualbox --help

echo "Vagrant and VirtualBox have been successfully installed!"
