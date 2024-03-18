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

## Docker Images
* basis of containers
* use `docker images` command to see list of all available images
* image is kind of like a git repository - they can be committed with changes and there could be multiple versions. If no version number is specified, the default is latest
* to pull a specific version of ubuntu image: `docker pull ubuntu:18.04'
* we can pull docker images form registry or create our own
  * use `docker search` in command line to look for specific images
* There are different types of images
  * **base:** has no parent, usually has an OS like ubuntu, busybox, or debian
  * **child:** built on base images iwth additional functionality
  * **official:** can be both base and child; images that officially maintained and supported by docker
  * **user:** can be both base and child; images created and shared by users. typically formatted as `user/image-name`

## Dockerfile
* simple text file that contains a list of commands that Docker client calls while creating an image
* automates image creation process
* similar to linux commands

`#specify base image  
FROM python:3.8`



