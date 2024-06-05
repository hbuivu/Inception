NAME = inception

all: up

up:
	@docker-compose -f ./srcs/docker-compose.yml up -d

build:
	@docker-compose -f  ./srcs/docker-compose.yml  build --pull 

down:
	@docker-compose -f ./srcs/docker-compose.yml down

stop : 
	@docker-compose -f ./srcs/docker-compose.yml stop

start : 
	@docker-compose -f ./srcs/docker-compose.yml start

status : 
	@docker ps

clean: down
	@docker rmi -f $$(docker images -qa)

fclean: clean
	@docker volume rm $$(docker volume ls -q)

re: fclean up



