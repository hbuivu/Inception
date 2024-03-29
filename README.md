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
docker push | push Docker image to a registery

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
ARG	| Use build-time variables. Example: `ARG VERSION = latest \ FROM nginx:$VERSION`
CMD	| Specify default commands to run when a container is started from an image. Syntax can be specified in shell form (CMD command param1 param2) or exec form (CMD ["executable", "param1", "param2"]). There can only be 1 CMD instruction in a Dockerfile
COPY | Copy files and directories into the image. COPY `<source path in host> <destination path in image>`
ENTRYPOINT | Specify default executable to be run when a container is started from image. Syntax: `ENTRYPOINT ["executable", "param1", "param2"]`. See below for more on difference between CMD and ENTRYPOINT
ENV | Set environment variables. Syntax: `ENV key1=value1 \ key2=value2`
EXPOSE | Describe which port(s) your application is listening on. It does not publish the ports
FROM | Specify base image from which you're building your new image. Must be the first instruction in a Dockerfile. Syntax: `FROM image_name[:tag] [AS name]`. Usually the tag denotes the version of the base image like `ubuntu:20.04` or `nginx:latest`. Only one FROM instruction can be used in a Dockerfile except in the case of a multi-stage build
HEALTHCHECK | Check a container's "health" on startup (is it running properly). Example: `HEALTHCHECK --interval=5s --timeout=3s \ CMD curl -f http://localhost/ || exit 1`
LABEL | Add metadata to Docker image. Used for organizational purposes and can be viewed using `docker inspect`. Example: `LABEL maintainer="example@example.com" \ LABEL description="This is a sample Dockerfile"`
MAINTAINER | Specify the author of an image. Generally, using LABEL to specify the maintainer is better. 
ONBUILD | Specify instructions for when the image is used as a build (base for another image)
RUN	| Execute commands during build process of Docker image. Each instruction creates a new layer in the image. Example: `RUN apt-get update && apt-get install -y curl` Since each command creates a layer, we can chain commands together using && to to minimize number of layers created
SHELL | Set the default shell of an image. By default, Docker uses `/bin/sh -c` as the shell. Syntax: `SHELL ["executable", "parameters"]` Example: `SHELL ["/bin/bash", "-c"]`
STOPSIGNAL | Specify the system call signal for exiting a container such as `STOPSIGNAL SIGINT`
USER | Set user and group ID that container should run as. Syntax: `USER <user>[:<group>]`. user is the username or UID of the user to switch to. gropu is the group name or GID (group identifier), if not specified, the primary group of the user is added. This instruction can be used for running containers with reduced privileges and improves security by limiting actions that container can perform
VOLUME | Create mount point in the docker container. Docker will create a new volume or use an existing volume at the specified path. Any data written to that path in the container will be stored outside container's writable layer which means it persists even after container is removed. It is commonly used to store information like config files, database files, log files, or any other "permanent" data. Volumes also make it easy to share data beteen multiple containers or between a container and host machine. Syntax: `VOLUME /path/to/mount/point` 
WORKDIR | Change working directory for RUN, CMD, ENTRYPOINT, COPY, and ADD instructions. 

### ENTRYPOINT VS CMD
* An ENTRYPOINT and CMD are two parts of the same where ENTRYPOINT is used first and CMD is used second by default.
* ENTRYPOINT must be overriden manually, otherwise it will always be run when we start our container. To override: `docker run --entrypoint="/path/to/entrypoint.sh" my-container`
* CMD will be overriden if we pass any other commands on the command line when starting the container

Let's take a look at the following sample:  
```
FROM debian:buster
COPY . /myproject
RUN apt-get update ...
ENTRYPOINT ["entrypoint1.sh"]
CMD ["cmd1", "cmd2"]
```
* `docker run my-container` Execution: entrypoint1.sh cmd1 cmd2
* `docker run my-container cmd3` Execution: entrypoint1.sh cmd3

**When should I use CMD and ENTRYPOINT**
* ENTRYPOINT is a great tool but it is not always transparent as it hides the command logic
* use ENTRYPOINT when your container MUST execute something at every start
* otherwise use CMD as it is more flexible  

**Source**: https://www.youtube.com/watch?v=U1P7bqVM7xM

### What are layers in a Dockerfile?
Each new instruction in a Dockerfile creates a **layer**. Layers are used to optimize caching and improve build speed. Docker uses a caching mechanism that checks if the command and its arguments match any previous commands in the Dockerfile. If yes, Docker reuses the cached layer instead of rebuilding. However, additional layers also mean more overhead and increased size for the image. When layering, consider the following:  
1. Combine related commands if you can
2. Use multi-stage builds to separate build-time dependencies from the final image. Multi-stage builds allow you to use different base images for your build vs runtime environments. Its basically like writing two Dockerfiles inside one
3. Optimize the order of your commands to take advantage of the caching mechanism

### Sample Dockerfile
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

## Docker Compose
### What is Docker Compose
* Docker Compose is a YAML(yet another markup language) file that runs multi-container Docker applications. You can use it to define the services, networks, and volumes needed for the application in a single file.
* filename: `compose.yaml`. can also be `docker-compose.yaml` or `docker-compose.yml`
* use `docker compose` command to interact with the file
* we can have multiple compose files to represent different configurations for different parts of the project

### Common keys in a Docker Compose file
To see the full documentation of all keys:  
https://docs.docker.com/compose/compose-file/compose-file-v3/

**SERVCES**
A service definition contains configuration that is applied to each container started for that service, similar to passing command line parameters to docker run. Anything specified in Docker file does not need to be specified again in YAML file  

* `services`: define containers that your app requires 
	* `image`: defines Docker image that continer will run
	* `build`: tells compose how to build the image if it doesn't exist yet; can be speicifed as a path or object with path specified under `context`
	* `context`: path to a directory containing a Dockerfile or a url to a git repository'
	* `args`: define build-time variables that can be used in the Dockerfile during image build process. These variables will be passed to the Docker build process when using the docker-compose build command. Pass as maping or a list. Omit arg values when specifying a build argument - default value is value in the environment where compose is running.
	* `network`: specify networks that the service should be set to
	* `target`: build specified stage as defined inside Dockerfile in the case of a multi-stage build
	*  `container_name`: specify a custom container name rather than a generated default name
	* `depends_on`: specify dependency between services. define order in which services should be started or stopped when using `docker-compose up` or `docker-compose down` commands.
	* `ports`: maps container ports to host machine ports
	* `volumes`: mounts host paths or named volumes into the container
	* `environment`: set environment variables in a container
	* `env_file`: add environment variables from a file
	* `expose`: expose ports without publishing them to the host machine. An exposed port refers to a port on a container that is made accessible to the outside world or to other containers. They will only be accessible to linked servies. Only the internal port can be specified. To publish a port use the -p option in `docker run`
	* `command`: override default command specified by Docker image
	* `restart`: controls the restart policy for the service
	* `healthcheck`: configures a health chekc for the service
	* `configs`: specify configurations for the service
	* `aliases`: specify alternative hostnames for this service on the network. network-scoped, which means the same service can have a different alias on a different network. 
	* `ipv4_address, ipv6_address`: specify a static IP address for containers for this service when joining the network
	* `secrets`: used to specify one or more secrets that should be made available to the services  in the stack. Examples: passowrds, API keys. Docker will store the file in an encrypted format and only make them available to the services at runtime. Use `docker secrete create` command

**VOLUMES**
create named volumes or bind mounts that can be reused cross mutiple services without relying on `volumes_from`. Volumes are used to persist data generated by and used by Docker containers.  
1. Named volumes: managed by Docker and created and managed outside of container lifecycle. Typically preferred for production use since they are easier to manage and provide better isolation.
2. Bind mounts: links a directory or file on the host machine to a directory in the container. Used for development because they allow you to make changes to your code and have them reflected in container immediately. 
	* Mounting refers to attaching a filesystem (or specific file or directory)from the host machine to a specific location within a container

* `volumes`:
	* `driver`: specify which volume driver should be used for this volume
	* `driver_opts`: specify a list of options as  key-value pairs to pass to the dirver for this volume
	* `external`: if set to `true`, specifies that this volume ha been created outside of compose
	* `name`: set a custom name for volume

**NETWORKS**
specify networks to be created
* `networks`:
	* `driver`: specifies network driver to use for network
		* `bridge` and `overlay` are two built-in drivers that we can use
	* `driver_opts`: specifies options to pass to the other network driver
	* `external`: specifies that the network is external to the Compose file
	* `name`: specifies the name of the network


### Example
The example application is composed of the following parts:  
* 2 services, backed by Docker images: webapp and database
* 1 secret (HTTPS certificate), injected into the frontend
* 1 configuration (HTTP), injected into the frontend
* 1 persistent volume, attached to the backend
* 2 networks

```
services:
  frontend:
    image: example/webapp
    ports:
      - "443:8043"
    networks:
      - front-tier
      - back-tier
    configs:
      - httpd-config
    secrets:
      - server-certificate

  backend:
    image: example/database
    volumes:
      - db-data:/etc/data
    networks:
      - back-tier

volumes:
  db-data:
    driver: flocker
    driver_opts:
      size: "10GiB"

configs:
  httpd-config:
    external: true

secrets:
  server-certificate:
    external: true

networks:
  # The presence of these objects is sufficient to define them
  front-tier: {}
  back-tier: {}
```

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

		
		 

	




