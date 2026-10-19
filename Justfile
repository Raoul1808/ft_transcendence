devcmd := "docker compose -f docker-compose-dev.yml"

devbuild *services:
    {{ devcmd }} build {{ services }}

devup *services: (devbuild services)
    {{ devcmd }} up -d {{ services }}

dev *args:
    {{ devcmd }} {{ args }}

up *services:
    docker compose up {{ services }}

down *services:
    docker compose down {{ services }}
