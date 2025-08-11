#!/bin/bash

# Entrypoint script for GitHub Actions Runner container

set -e

echo "Starting GitHub Actions Runner container..."

# Check if runner is configured
if [ ! -f ".runner" ]; then
    echo "Runner not configured. Checking for auto-configuration..."
    
    # Check if we have the required environment variables for auto-configuration
    if [ -n "${GITHUB_URL:-}" ] && [ -n "${GITHUB_TOKEN:-}" ]; then
        echo "Auto-configuring runner with URL: $GITHUB_URL"
        
        # Configure the runner with the provided environment variables
        ./config.sh --url "$GITHUB_URL" --token "$GITHUB_TOKEN" --unattended --replace
        
        # Check if configuration was successful
        if [ -f ".runner" ]; then
            echo "Runner configured successfully!"
        else
            echo "Failed to configure runner. Exiting."
            exit 1
        fi
    else
        echo "Runner not configured and auto-configuration not available."
        echo "Missing required environment variables: GITHUB_URL and/or GITHUB_TOKEN"
        echo "Example:"
        echo "  docker run -it --rm skunklabz/ubuntu-24.04-runner:latest"
        echo "  ./config.sh --url https://github.com/your-org/your-repo --token YOUR_TOKEN"
        echo "  ./run.sh"
        exec bash
    fi
fi

# Start the runner
echo "Starting runner..."
exec ./run.sh
