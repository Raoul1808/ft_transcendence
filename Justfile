devcmd := "docker compose -f docker-compose-dev.yml"

devbuild *services:
    {{ devcmd }} build {{ services }}

devup *services: (devbuild services)
    {{ devcmd }} up -d {{ services }}

dev *args:
    {{ devcmd }} {{ args }}

build *services:
    docker compose build {{ services }}

up *services: (build services)
    docker compose up {{ services }}

down *services:
    docker compose down {{ services }}
