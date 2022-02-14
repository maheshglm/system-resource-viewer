#!/bin/bash

#This is a simple to deploy docker-compose on to the Azure App service

RESOURCE_GROUP="smartcow"
CLUSTER_NAME="smartcow"
APP_SERVICE_PLAN="smartcow"
LOCATION="eastus"

APP_NAME="system-resource-api"
WEB_NAME="system-resource-monitor"

API_IMAGE="mahesh1985/sys-resource-view-api:03429351723713db7c7834ad146c6e1fe4b4c091"
API_PORT="5000"

WEB_IMAGE="mahesh1985/sys-resource-view-web:758213cf2f881964c5fe2560295e6577e72bcc14"
WEB_PORT="8080"

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


echo "Create a Web app to deploy the API continer"

az webapp create \
    --resource-group $RESOURCE_GROUP \
    --plan $APP_SERVICE_PLAN \
    --name $APP_NAME \
    --deployment-container-image-name $API_IMAGE


az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $APP_NAME \
    --settings WEBSITES_PORT=$API_PORT


az webapp config container set \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --docker-custom-image-name $API_IMAGE


echo "Visit the api is running https://$APP_NAME.azurewebsites.net/stats"


echo "Create a Web app to deploy the Web (React) continer"

az webapp create \
    --resource-group $RESOURCE_GROUP \
    --plan $APP_SERVICE_PLAN \
    --name $WEB_NAME \
    --deployment-container-image-name $WEB_IMAGE


az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $WEB_NAME \
    --settings WEBSITES_PORT=$WEB_PORT API_URL="https://$APP_NAME.azurewebsites.net"


az webapp config container set \
    --name $WEB_NAME \
    --resource-group $RESOURCE_GROUP \
    --docker-custom-image-name $WEB_IMAGE


echo "Delete resources"

# az group delete --name $RESOURCE_GROUP