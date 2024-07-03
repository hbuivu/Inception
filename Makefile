NAME = inception

all: volume up
# all: up

volume: 
	mkdir -p ~/data
	mkdir -p ~/data/wp
	mkdir -p ~/data/db
	mkdir -p ~/data/php

up:
	@docker-compose -f ./srcs/docker-compose.yml up --build -d 

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
	sudo rm -rf ~/data/wp/* 
	sudo rm -rf ~/data/db/* 
	sudo rm -rf ~/data/php/* 

re: fclean up

# build:
# @docker-compose -f  ./srcs/docker-compose.yml build --pull 