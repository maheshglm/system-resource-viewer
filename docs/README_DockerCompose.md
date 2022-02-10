# React-Flask Application

Containerized React web frontend and Flask Api are configured to run using docker-compose as services

# Requirements
docker and docker-compose to be installed

## Start Application

Build the containers using docker-compose
```
    docker-compose build
```

Run services in detach mode

```
    docker-compose up -d
```

## Test Application

1. Visit `http://localhost`
2. React frontend should be up and page should display CPU and RAM statistics


## Considerations

1. Build context is used instead of images, so docker-compose build should rebuild the images from source code
2. Demonstrated reading environment file in docker-compose yaml
3. Always Api service will start first and followed by web service, it is to avoid exposing web application to the end users before backend is up
4. Creating volumes is not required in this case
5. Creating networks is not required in this case as web is configured to use localhost:5000, creating network would have been required if web is talking to api by service name


