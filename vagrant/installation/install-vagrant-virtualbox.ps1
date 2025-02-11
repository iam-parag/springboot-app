# Ensure you're running as Administrator (Right-click -> Run as Administrator)
$ErrorActionPreference = "Stop"

# Define URLs for downloading Vagrant and VirtualBox
$vagrantUrl = "https://releases.hashicorp.com/vagrant/2.3.4/vagrant_2.3.4_x86_64.msi"  # Update this version if needed
$virtualboxUrl = "https://download.virtualbox.org/virtualbox/6.1.32/VirtualBox-6.1.32-149290-Win.exe"  # Update this version if needed

# Define file paths for downloading installers
$vagrantInstaller = "$env:TEMP\vagrant_installer.msi"
$virtualboxInstaller = "$env:TEMP\virtualbox_installer.exe"

# Download Vagrant Installer
Write-Host "Downloading Vagrant installer..."
Invoke-WebRequest -Uri $vagrantUrl -OutFile $vagrantInstaller

# Download VirtualBox Installer
Write-Host "Downloading VirtualBox installer..."
Invoke-WebRequest -Uri $virtualboxUrl -OutFile $virtualboxInstaller

# Install Vagrant
Write-Host "Installing Vagrant..."
Start-Process -FilePath $vagrantInstaller -ArgumentList "/quiet" -Wait

# Install VirtualBox
Write-Host "Installing VirtualBox..."
Start-Process -FilePath $virtualboxInstaller -ArgumentList "/S" -Wait

# Clean up installer files
Write-Host "Cleaning up installer files..."
Remove-Item $vagrantInstaller
Remove-Item $virtualboxInstaller

# Check Vagrant version
Write-Host "Verifying Vagrant installation..."
vagrant --version

# Check VirtualBox version
Write-Host "Verifying VirtualBox installation..."
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version

Write-Host "Vagrant and VirtualBox installation complete!"
