# System Resource Viewer + Kubernetes (docker-desktop)

This documentation having instruction to deploy a simple Flask Api with React frontend application onto Kubernetes cluster running on docker-desktop. 

Since, LoadBalancer service type not applicable to the docker-desktop K8 cluster, NodePort is used to access the React front end application on the node port.

Deployment manifest files are available in `k8` folder.

## Requirements

- Docker
- Kubernetes cluster should be up & running (docker-desktop)

## Create a namespace

Kubernetes creates resources in default namespace if not mention explicitly. 
But for production it is a standard practice to create namespaces which are a way to divide cluster resources between multiple users or teams like QA, Dev etc...

```
kubectl apply -f namespace.yml
```

## Deploy Api

Deployment yaml manifest file for API is available here `k8/sol1-deploy-api.yml`

```
    kubectl apply -f k8/sol1-deploy-api.yml

    #check service, deployment and pod are created
    #pod status should be Running
    #service on ClusterIP created with port mapping to 5000
    #replicaset with 1 desired and 1 current should be created
    
    kubectl get all -l app=resourceapi -n smartcow
```

1. Deployment is created based on the custom API image which is built in local and pushed to Dockerhub
2. The deployment manifest file will pull the image from DockerHub
3. ClusterIP service is used to expose the API endpoint within the cluster
4. It exposes the port 5000 which is the default port through which Flask app is served
5. This endpoint will be accessed by frontend application
6. NodePort should not be used as it exposes the API to public
7. Deployment is configured with 1 replica for testing purpose

## Deploy Web

Deployment yaml manifest file for API is available here `k8/sol1-deploy-web.yml`

```
    kubectl apply -f k8/sol1-deploy-web.yml

    #check service, deployment and pod are created
    #pod status should be Running
    #service on NodePort created with port mapping to 30000 (defined explicitly in yaml)
    #replicaset with 1 desired and 1 current should be created
    
    kubectl get all -l app=resourceweb -n smartcow
```

1. Deployment is created based on the custom API image which is built in local and pushed to Dockerhub
2. The deployment manifest file will pull the image from DockerHub
3. Frontend should be accessible publicly, hence NodePort service is used
4. Port 8080 is exposed on the pod by the NodePort service and maps to a higher range port on the Node 
5. Deployment is configured with 1 replica for testing purpose
6. LoadBalancer of type is not applicable, hence NodePort is used.
7. Deployment is configured with 1 replica for testing purpose


## Test Application

After successfully deploying all above objects, we can access application on `http://localhost`