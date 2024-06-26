NAME = ng

up:
	docker build -t ngtest .
	docker run -d -p 443:443 -p 80:80 --name ngtest ngtest
down: 
	docker stop ngtest
	docker rm ngtest
	docker rmi ngtest
