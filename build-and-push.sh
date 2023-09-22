#!/bin/bash

# Check if an argument is provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 {go-api|node-api}"
    exit 1
fi

API_TYPE=$1
VERSION=${2:-latest}
PLATFORM=$3

# Validate the argument
if [[ $API_TYPE != "go-api" ]] && [[ $API_TYPE != "node-api" ]]; then
    echo "Invalid argument. Use 'go' or 'node'"
    exit 1
fi

# Change directory to the respective *-api directory
cd $API_TYPE || exit 1

echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin

# Define the image name based on the API type
IMAGE_NAME=ghcr.io/$USERNAME/$API_TYPE:$VERSION

echo $IMAGE_NAME

# Build the Docker image
docker build -t $IMAGE_NAME . $PLATFORM

# Push the Docker image to the GitHub Container Registry
docker push $IMAGE_NAME

echo "Process completed successfully!"
