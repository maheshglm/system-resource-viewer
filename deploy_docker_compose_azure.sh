#!/bin/bash

#This is a simple to deploy docker-compose on to the Azure App service

RESOURCE_GROUP="smartcow"
CLUSTER_NAME="smartcow"
APP_SERVICE_PLAN="smartcow"
LOCATION="eastus"
APP_NAME="system-resource-viewer"
DOCKER_COMPOSE_PATH="docker-compose.azure.yml"

echo "Create Azure Resoure Group"

az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION

echo "Create Azure App service plan to host our application"

az appservice plan create \
    --name $APP_SERVICE_PLAN \
    --resource-group $RESOURCE_GROUP \
    --sku S1 \
    --is-linux  \
    --location $LOCATION


echo "Deploy Docker compose on Az web app"

az webapp create \
    --resource-group $RESOURCE_GROUP \
    --plan $APP_SERVICE_PLAN \
    --name $APP_NAME \
    --multicontainer-config-type compose \
    --multicontainer-config-file $DOCKER_COMPOSE_PATH


echo "Visit http://$APP_NAME.azurewebsites.net"