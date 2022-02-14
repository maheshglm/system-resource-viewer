#!/bin/bash

echo "Running API manifest"

kubectl apply -f sol2-deploy-api.yml


echo "Running Web manifest"

kubectl apply -f sol2-deploy-web.yml

echo "Running Ingress"

kubectl apply -f ingress.yml
