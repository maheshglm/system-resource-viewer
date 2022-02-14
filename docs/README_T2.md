# System Resource Viewer (Flask + React) Deploy on Azure Cloud

 This documentation having instruction to deploy a simple Flask Api with React frontend application on Azure Cloud

 Easiet approach I could see is to spin up a AKS cluster and deploy the solution2 `README_T3_k8_sol2.md` on cluster. But while I am using I can use LoadBalancer service of the cloud instead of minikube.

 1. Approach1: Deploy application on AKS cluster
 2. Approach2: Deploying application using Docker compose feature on Azure Container App service (Its preview feature but works fine for current scenario)
 3. Approach3: Deploy API on azure container app (with inboud access restricted from frontend FQDN) and deploy React App as another container app

## Approach 1

1. Crete AKS cluster in Azure with `k8/create_aks_cluster.sh`
2. Deploy manifest yaml in below sequence:
    1. kubectl apply -f k8/namespace.yml
    2. kubectl apply -f k8/aks-deploy-api.yml
    3. kubectl apply -f k8/configmap.yml (Update API service external address in the api_url)
    4. kubectl apply -f k8/aks-deploy-web.yml
3. Access application on External IP of Web application service

## Approach 2

I am utilizing Preview feature of Azure App service deployment using docker-compose.

Sequence of steps are updated in `deploy_docker_compose_azure.sh`


## Approach 3

I would recommend using Kubernetes way for deploying containerized applications, but we can avoid K8s by deploying each containarized app as independent application. 

Though we can use Terraform for automatic provisioning, I am trying to explain the solution through AZ CLI due to time constraints.

Sequence of steps are updated in `deploy_apps_azure.sh`

Following above bash script will create 2 app services

1. https://system-resource-api.azurewebsites.net/stats which is API end point
2. https://system-resource-monitor.azurewebsites.net/ which is frontend react application

As per requirement, we should expose only Frontend application to the internet and API endpoint from internet should be stopped.

I created a Access Restrictions rule to allow access to Backend API only from frontend (IPV4) address. to create that I have followed below steps:

1. Navigate to `system-resource-api` configuration in the azure portal
2. Settings -> Networking
3. Add `Access Restrictions`
4. Create a New rule
5. Set Priority as 1 and give a name ex: "AllowOnlyFromFrontEnd"
6. Selection 'Action' as "Allow"
7. Add FrontEnd app IP address in the "IP Address Block"
8. Save the rule.


The new rule will stop accessing API from internet and FrontEnd will be running as it is.
