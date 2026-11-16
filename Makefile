.RECIPEPREFIX := >
.PHONY: help build run stop restart down logs ps health clean

help:
> @echo Available commands:
> @echo   make build   - build the Docker images
> @echo   make run     - start the application in the background
> @echo   make stop    - stop the containers (data is kept)
> @echo   make restart - restart the containers
> @echo   make down    - remove containers and network (data is kept)
> @echo   make logs    - follow the logs
> @echo   make ps      - show container status
> @echo   make health  - call the health endpoint
> @echo   make clean   - remove everything including volumes

build:
> docker compose build

run:
> docker compose up -d --build

stop:
> docker compose stop

restart:
> docker compose restart

down:
> docker compose down

logs:
> docker compose logs -f --tail 50

ps:
> docker compose ps

health:
> curl -fs http://localhost:8080/health.php

clean:
> docker compose down -v
