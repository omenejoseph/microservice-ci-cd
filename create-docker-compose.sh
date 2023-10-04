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
      - "8080:8080"
    networks:
      - backend

  node-api:
    image: ghcr.io/${USERNAME}/node-api:${VERSION}
    ports: 
      - "3000:3000"
    networks:
      - backend  

  db:
    image: "mysql:8.1.0" 
    volumes:
       - db-data:/var/lib/mysql/data
    environment:
      - MYSQL_ROOT_PASSWORD=root  
    networks:
      - backend

volumes:
  db-data:
networks:
  backend:
EOL

echo "docker-compose.yml generated!"
