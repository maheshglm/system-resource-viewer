#!/bin/bash


echo "Deleting Ingress"

kubectl delete -f ingress.yml


echo "Deleting Web manifest"

kubectl delete -f sol2-deploy-web.yml


echo "Deleting API manifest"

kubectl delete -f sol2-deploy-api.yml
