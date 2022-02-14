# React-Nginx

A simple React frontend application, which reads the current RAM and CPU usage from Flask-Python based Api running on 5000 port and shows the statistics in the browser.

This project uses multi-stage docker images in which Node.js layer is used to install, build the source code, while Nginx webserver acts as a reverse proxy and serves the React front end to the end users.

## Requirements
Docker


## Build the image

```
docker build -t web:latest .
```

## Start a container

```
docker run --detach -p 80:8080 --name web web:latest
```

## Testing

. Ensure api is running a container with command `docker ps`
. Open a browser and navigate to `http://localhost`
. It should display React web page with CPU: 0.0 and RAM 0.0


## Considerations

1. Container should not be run as root user, hence additional configuration required for Nginx (default.conf and nginx.conf) to start nginx daemon with non-root user (and port > 1024)
2. Avoid using :latest base images, prefer to use official images
3. Multi-stage builds are recommended to reduce the image size
4. Multi-stage builds helped to wrap React application on top of Nginx web server which helps to avoid creating additional container for Nginx explicitly
5. Dockerignore needs to be added to exclude unwanted content to copied into the container which will again increases the size of the image
6. The configuration for nginx to run as non-root user is referred from Google
7. The api url in App.js was hardcoded but to make it runnable with production scenarios, have used env.sh to inject variables declared in .env into container.
8. Explored multiple solutions like using environment specific files (ex: .env.prod, .env.dev) and injecting with docker build & environment variables, but this process looks easy as its just a one time activity to define variable in .env file, consume in application and override at runtime either through docker run or docker-compose (note: explore this solution on the internet)


## Integration with GitHub Actions

Continuous Integration pipeline is added using GitHub Actions to build the image and push the images to Docker Hub
Pipeline for building web docker image is available here: `.github/workflows/build_web_docker.yml`