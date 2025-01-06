#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Download and install Minikube
echo "Downloading Minikube..."
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
echo "Minikube installed successfully."

# Start Minikube with 4 nodes in a multi-node cluster
echo "Starting Minikube with 4 nodes..."
minikube start --nodes 4 -p multinode-k8s

# Label nodes with specific roles and types
echo "Labelling nodes..."
kubectl label node multinode-k8s-m02 multinode-k8s-m03 multinode-k8s-m04 node-role.kubernetes.io/worker=worker
kubectl label node multinode-k8s-m02 type=application
kubectl label node multinode-k8s-m03 type=database
kubectl label node multinode-k8s-m04 type=dependent_services

echo "Node labelling completed successfully."
