# flask-gunicorn-docker

A simple Flask api using Gunicorn on Docker, which reads the current RAM and CPU usage and can be `GET` at `/stats` endpoint. 

## Requirements
- Docker

## Build the image

```
docker build -t app:latest .
```

## Start a container

with default gunicorn workers which is 5

```
docker run --shm-size=256m --detach -p 5000:5000 --name api app:latest
```

can override gunicorn workers using `-e GUNICORN_WORKERS`

```
docker run --shm-size=256m --detach -p 5000:5000 --name api -e GUNICORN_WORKERS=<number> app:latest
```

## Testing

. Ensure api is running a container with command `docker ps`
. Run `curl localhost:5000/stats`
. It should produce output in this format `{"cpu":<percentage>,"ram":<percentage>}`

## Considerations

1. Python3 slim image has been used to reduce the image size (prefer to use official images as base)
2. --shm-size is to set a bigger shared memory size. Gunicorn has a config entry to use shared memory (/dev/shm) vs disk (/tmp) for health checks to avoid timeouts (referred this point from Google)
3. Container should not be run as root user, hence configured a new user and group to run the application
4. Expose only relevant ports in the Dockerfile
5. For easy maintanance using ARG and ENV instructions is encouraged
6. Avoid using :latest base images

## Integration with GitHub Actions

Continuous Integration pipeline is added using GitHub Actions to build the image and push the images to Docker Hub
Pipeline for building api docker is available here: `.github/workflows/build_api_docker.yml`