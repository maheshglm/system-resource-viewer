# React-Flask Application

Running multi-container application (React web frontend and Flask Api applications) using docker-compose on local

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
4. Github actions configured to build and push the images to docker hub
5. docker-compose.prod.yaml created, it will pull images from docker hub

