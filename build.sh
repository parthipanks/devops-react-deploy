#!/bin/bash
set -e

IMAGE_NAME="devops-react"
TAG="${1:-latest}"

echo "Building image: ${IMAGE_NAME}:${TAG}"
docker build -t "${IMAGE_NAME}:${TAG}" .

echo "Build complete."
