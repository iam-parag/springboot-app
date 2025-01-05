# Exit on errors
$ErrorActionPreference = "Stop"

# Download Minikube executable
Write-Host "Downloading Minikube..."
Invoke-WebRequest -Uri "https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe" -OutFile "minikube.exe"
Move-Item -Path ".\minikube.exe" -Destination "C:\Windows\System32\minikube.exe"
Write-Host "Minikube installed successfully."

# Start Minikube with 4 nodes in a multi-node cluster
Write-Host "Starting Minikube with 4 nodes..."
minikube start --nodes 4 -p multinode-k8s

# Label nodes with specific roles and types
Write-Host "Labelling nodes..."
kubectl label node multinode-k8s-m02 multinode-k8s-m03 multinode-k8s-m04 node-role.kubernetes.io/worker=worker
kubectl label node multinode-k8s-m02 type=application
kubectl label node multinode-k8s-m03 type=database
kubectl label node multinode-k8s-m04 type=dependent_services

Write-Host "Node labelling completed successfully."
