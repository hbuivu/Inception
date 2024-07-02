NAME = inception

all: volume build up

volume: 
	mkdir -p ~/data
	mkdir -p ~/data/wp
	mkdir -p ~/data/db
	mkdir -p ~/data/php

build:
	@docker-compose -f  ./srcs/docker-compose.yml build --pull 

up:
	@docker-compose -f ./srcs/docker-compose.yml up -d

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