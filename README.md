# Inception
## What's Docker?
* A tool that allows developers to deploy applications in a sandbox (containers) to run on the host operating system
* Works kind of like a virtual machine but has less overhead
* allows users to package an app with all dependencies into a standardized unit for software development
* container-based applications can be deployed easily and consistently, and can be run anywhere

## Basic Commands
Command | Description
:----------- | :-------------
docker pull <image> | fetches image from Docker registry
docker images | see list of all images on your system
docker run <image> <commands> | run a docker container based on image with some command
docker ps | show all containers currently running
docker ps -a | shows all container that we had already run
docker run -it | run multiple commands inside container
docker run --help | see list of run flags
docker rm <containerID1, containerID2, ...> | delete containers after use; you will seee the ID echoed back
docker rm $(docker ps -a -q -f status=exited | deletes all containers with exited status
docker container prune | same as command above for later versions of docker
docker run --rm | automatically deletes container once it's exited
docker rmi | delete images
docker run -d -P --name <wechoosethisname> <image> | detach terminal and publish all exposed ports

## Terminology
Terminology | Definition
:----------- | :-------------
Images | blueprints for our applications
Containers | created from images and used to run application
Docker Daemon | background service running on the host that manages building, running, and distributing Docker containers
Docker Client | command line tool allowing user to interact with the daemon
Docker Hub | registry of Docker images
Detached mode | container continues to run in the background even if the terminal is closed
Exposed ports | allows making network services running inside a container accessible outside or to other containers

## Other concepts



