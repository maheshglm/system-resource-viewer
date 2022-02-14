#!/bin/bash

RESOURCE_GROUP="smartcow"
CLUSTER_NAME="smartcow"
LOCATION="eastus"

echo "Creating AZ resource group"

az group create \
    --name $RESOURCE_GROUP 
    --location $LOCATION


echo "Creating AKS Cluster with 2 Nodes"

az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --node-count 2 \
    --enable-addons http_application_routing \
    --generate-ssh-keys \
    --node-vm-size standard_a2_v2    \
    --network-plugin azure  \
    --location $LOCATION

echo "Setting AKS context"

az aks get-credentials \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME