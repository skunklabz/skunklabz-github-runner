#!/bin/bash

# Entrypoint script for GitHub Actions Runner container

set -e

echo "Starting GitHub Actions Runner container..."

# Check if runner is configured
if [ ! -f ".runner" ]; then
    echo "Runner not configured. Please configure it first."
    echo "Example:"
    echo "  docker run -it --rm skunklabz/ubuntu-24.04-runner:latest"
    echo "  ./config.sh --url https://github.com/your-org/your-repo --token YOUR_TOKEN"
    echo "  ./run.sh"
    exec bash
fi

# Start the runner
echo "Starting runner..."
exec ./run.sh
