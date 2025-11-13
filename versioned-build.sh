#!/bin/bash
set -euo pipefail

# 1) Make a timestamp like 20251112_1530 (year-month-day_hour-minute)
VERSION=$(date +%Y%m%d%H%M)

# 2) Define your image name
IMAGE="laly9999/hello-ci"

# 3) Build the image with the timestamp tag
docker build -t "$IMAGE:$VERSION" .

# 4) (Optional) also tag as 'latest' for convenience
docker tag "$IMAGE:$VERSION" "$IMAGE:latest"

# 5) Push both tags
docker push "$IMAGE:$VERSION"
docker push "$IMAGE:latest"

# 6) Print what we pushed
echo "Pushed:"
echo "  $IMAGE:$VERSION"
echo "  $IMAGE:latest"

