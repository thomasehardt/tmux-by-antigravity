#!/usr/bin/env bash
set -euo pipefail

# Run from the root of the repository
cd "$(dirname "$0")/.."

echo "=> Building test image..."
docker build -t tmux-config-test -f tests/Dockerfile .

echo "=> Running installation test in container..."
docker run --rm tmux-config-test

echo "=> Test completed successfully!"
