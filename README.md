# Inception
## What's Docker?
* A tool that allows developers to deploy applications in a sandbox (containers) to run on the host operating system
* Works kind of like a virtual machine but has less overhead. It occupies less memory space, has quicker bootup, is easy to scale, and volume storage can be shared across host and the containers
* allows users to package an app with all dependencies into a standardized unit for software development
* container-based applications can be deployed easily and consistently, and can be run anywhere

### Architectural difference between Docker and VM
**DOCKER**  
* Infrastructure - physical machine that app is running on like CPU, hard disk, etc
* Host Operating System - computer OS
* Docker - builds and runs the app for you
* App - individual containers all running on one network (or if you have more than one type of app, multiple networks)
![image](https://github.com/hbuivu/Inception/assets/26291116/bcd75d70-974b-484f-a64b-d7e0e3fa840c)  
**VM**
* Infrastructure - physical machine that app is running on like CPU, hard disk, etc
* Hypervisor - software that creates and manages VMs
* Each VM has it's own app and guest operating system
![Alt text](image-1.png)
### How Docker works
1. Write a Dockerfile to build a Docker image
2. `docker build` -> Docker daemon reads instructions in Dockerfile and builds the image
3. `docker run` -> Docker daemon creates a container from image and runs app inside container
4. Docker can view, stop, and manage containers. We can also push Docker image to a registry to share with others

## Basic Commands
Command | Description
:----------- | :-------------
docker build | build Docker image from a Dockerfile
docker pull | fetches image from a registry
docker images | see list of all images on your system
docker run | run a docker container based on Docker image
docker run --rm | automatically deletes container once it's exited
docker ps | show all containers currently running
docker rm | delete containers after use; you will seee the ID echoed back
docker container prune | same as command above for later versions of docker
docker rmi | delete images
docker stop | stop running container
docker exec | execute a command in a running container
docker logs | view logs for a container

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
* text file that contains a list of commands that Docker calls to create an image
* specifies base image to use, dependencies, software to install, and any other configs or scripts needed to set up the environment for the app to run
* similar to linux commands

### Dockerfile commands
Terminology | Definition
:----------- | :-------------
ADD | Add local or remote files and directories to Docker image. Similar to copy, but it can copy files from a remote URL (which COPY cannot), automatically extract compressed files into destination directory, and allows specifying a URL where Docker will download the source and copy it into the image
ARG	| Use build-time variables. ex: ARG VERSION = latest \ FROM nginx:$VERSION
CMD	| Specify default commands to run when a container is started from an image. Syntax can be specified in shell form (CMD command param1 param2) or exec form (CMD ["executable", "param1", "param2"]). There can only be 1 CMD instruction in a Dockerfile
COPY | Copy files and directories into the image. COPY `<source path in host> <destination path in image>`
ENTRYPOINT | Specify default executable to be run when a container is started from image. Syntax: `ENTRYPOINT ["executable", "param1", "param2"]`. See below for more on difference between CMD and ENTRYPOINT
ENV | Set environment variables. Syntax: `ENV key1=value1 \ key2=value2`
EXPOSE | Describe which port(s) your application is listening on. It does not publish the ports
FROM | Specify base image from which you're building your new image. Must be the first instruction in a Dockerfile and there can only be 1 instruction. Syntax: `FROM image_name[:tag] [AS name]`. Usually the tag denotes the version of the base image like `ubuntu:20.04` or `nginx:latest`
HEALTHCHECK | Check a container's "health" on startup (is it running properly). Example: `HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1`
LABEL | Add metadata to an image.
MAINTAINER | Specify the author of an image.
ONBUILD | Specify instructions for when the image is used in a build.
RUN	| Execute build commands.
SHELL | Set the default shell of an image.
STOPSIGNAL | Specify the system call signal for exiting a container.
USER | Set user and group ID.
VOLUME | Create volume mounts.
WORKDIR | Change working directory.

**Sample** 
```
# specify base image  
FROM python:3.8

# set a directory for the app
WORKDIR /usr/src/app

# copy all the files to the container
COPY . .

# install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# define the port number the container should expose
EXPOSE 5000

# run the command
CMD ["python", "./app.py"]
```

## Deploying application
### Docker push
* publish image on a registry
* docker push username/file
* AWS Beanstalk is a PaaS that can help to scale, monitor, and update your app

## Multi-Container Environments
* There is usually a database or storage associated with apps (see Redis and Memcached)
* keep separate containers for separate services
* cURL request - a command-line tool for transferring data with URLs. For example, curl https:://example.com will send and HTTP GET request to the provided url and print response to the terminal
* Must connect containers to each other

### Docker Network
* `docker container ls` (same as `docker ps`) -> see container id and information
* docker creates three automatic networks
	* bridge -> this is the default network in which containers are run
	* host
	* none
	* we can inspect the network with `docker network inspect <network name>`
	* use IP address given here to allow two containers to talk to each other
* We need to isolate our network (since bridge is shared by every container)
	* use `docker network` command to create our own network
	* `docker network create <name>`
	* creates a new bridge network
		* uses a software bridge - containers connected to same bridge network can communicate
		* isolated from containers not connected to bridge network
		* Docker bridge driver automatically installs rules in host machine so that containers on different bridge networks cannot communicate directly with each other
* launch containers inside network using `--net` flag
	* don't forget to stop and remove other container so that it can be launched in new network
	* containers can also resolve a container name to an IP address - called automatic service discovery

## Docker Compose
* A tool for defining and running multi-container Docker applications  
* provides a config file called docker-compose.yml to be used to bring up an applicatin and the suite of services it dpeends on with just one command
* A YAML file can contain:
	* version
	* services:
		* image -> ALWAYS REQUIRED
		* container_name
		* environment
		* ports
		* volumes
		* command
		* depends_on
		* ports
	* volumes
* Compose will also create the network automatically

		
		 

	




