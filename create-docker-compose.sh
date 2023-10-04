#!/bin/bash

# Argument check
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION="$1"

# Generate docker-compose.yml
cat <<EOL > docker-compose-prod.yml
version: "3.2"
services: 
  go-api:
    image: ghcr.io/${USERNAME}/go-api:${VERSION}
    ports: 
      - "8081:8080"
    networks:
      - backend
      - web
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.go-api.rule=Host(`go-api.omenejoseph.co.uk`)"
      - "traefik.http.routers.go-api.entrypoints=web"  

  node-api:
    image: ghcr.io/${USERNAME}/node-api:${VERSION}
    ports: 
      - "3000:3000"
    networks:
      - backend  
      - web
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.node-api.rule=Host(`node-api.omenejoseph.co.uk`)"
      - "traefik.http.routers.node-api.entrypoints=web"    

  db:
    image: "mysql:8.1.0" 
    volumes:
       - db-data:/var/lib/mysql/data
    environment:
      - MYSQL_ROOT_PASSWORD=root  
    networks:
      - backend

  traefik:
    image: traefik:v2.5
    ports:
      - "80:80"
      - "8080:8080" # The Web UI (optional)
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command:
      - --api.insecure=true # Enables the web UI
      - --providers.docker=true
      - --providers.docker.exposedbydefault=false
      - --entrypoints.web.address=:80
    networks:
      - web  
    
volumes:
  db-data:
networks:
  backend:
  web:


echo "docker-compose.yml generated!"
