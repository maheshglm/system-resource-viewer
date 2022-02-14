# System Resource Viewer + Kubernetes (minikube)

This documentation having instruction to deploy a simple Flask Api with React frontend application onto Kubernetes cluster running on minikube. 

Both React and Flask services are running on ClusterIP, so React can communicate to Flask api intervally using service name. Ingress controller is created routing the traffic from external to React service. So, Flask api is not exposed to external users but only react service can communicate to api.

Note: I am able to curl backend service (resourceapi) endpoint from frontend POD. but react application is not fetching RAM and CPU details from backend api. I tried to debug it but due to time constraint, I couldnt fix this issue.

```
k exec -it resourceweb-55c6c9565c-9tk8g -n smartcow -- bash
nginx@resourceweb-55c6c9565c-9tk8g:/usr/share/nginx/html$ curl http://resourceapi:5000/stats
{"cpu":4.0,"ram":20.9}
```

So, I decided to use expose API via ingress, so the API url is configured in the config map as http://<minikubeip>/

Deployment manifest files are available in `k8` folder.

## Requirements

- Docker
- minikube (Ingress addon is enabled)

## Create a namespace

Kubernetes creates resources in default namespace if not mention explicitly. 
But for production it is a standard practice to create namespaces which are a way to divide cluster resources between multiple users or teams like QA, Dev etc...

```
kubectl apply -f k8/namespace.yml
```

## Create a configmap

We can add the environment variables directly in the yaml manifest files, but for reusability, we can create configmap and can run the in the cluster so other services can consume.

Note: Dont forget to update minikube ip for the api_url variable. 

```
kubectl apply -f k8/configmap.yml
```

## Deploy Api

Deployment yaml manifest file for API is available here `k8/sol1-deploy-api.yml`

1. Deployment is created based on the custom API image which is built in local and pushed to Dockerhub
2. The deployment manifest file will pull the image from DockerHub
3. ClusterIP service is used to expose the API endpoint within the cluster
4. It exposes the port 5000 which is the default port through which Flask app is served
5. NodePort should not be used as it exposes the API to public
6. Deployment is configured with 1 replica for testing purpose

Deploy the api

```
    cd k8
    kubectl apply -f deploy-api.yaml

    #check service, deployment and pod are created
    #pod status should be Running
    #service on ClusterIP created with port mapping to 5000
    #replicaset with 1 desired and 1 current should be created
    
    kubectl get all -l app=resourceapi
```

## Deploy Web

Deployment yaml manifest file for API is available here `k8/sol1-deploy-web.yml`

1. Deployment is created based on the custom API image which is built in local and pushed to Dockerhub
2. The deployment manifest file will pull the image from DockerHub
3. ClusterIP service is used to expose the frontend within the cluster
5. Deployment is configured with 1 replica for testing purpose
 

```
    kubectl apply -f k8/sol2-deploy-web.yml

    #check service, deployment and pod are created
    #pod status should be Running
    #replicaset with 1 desired and 1 current should be created
    
    kubectl get all -l app=resourceweb
```

## Deploy Ingress

Since LoadBalancer does not work in minikube (local desktop), I went ahead with ingress controller to route traffic to React app from external users. We can set up rules for routing traffic using ingress without LoadBalancers or exposing each service on the node.

1. Create a rule to rote traffic from resourceweb:8080 to / root path of externalip/minikube ip/dns name
2. Create a rule to rote traffic from resourceapi:5000 to /stats path of externalip/minikube ip/dns name


```
    kubectl apply -f k8/ingress.yml

    #2 services should be running from this command

    kubectl get ingress -n smartcow
```

## Access the application

After successfully deploying all above objects, we can access application on `http://<minikube ip>`