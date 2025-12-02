#!/bin/bash
set -e

echo "Stopping old containers (if any)..."
docker-compose down || true

echo "Starting app with docker-compose..."
docker-compose up -d

echo "Deployment complete!"
