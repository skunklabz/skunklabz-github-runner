#!/bin/bash

# Test Setup Script for SkunkLabz GitHub Runner
# This script validates that the setup is working correctly

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "=== SkunkLabz GitHub Runner Setup Validation ==="
echo

# Test 1: Check if submodule exists and is initialized
print_status "Checking runner-images submodule..."
if [ -d "runner-images" ] && [ -f "runner-images/README.md" ]; then
    print_status "✓ Submodule exists and is initialized"
else
    print_error "✗ Submodule not found or not initialized"
    echo "Run: git submodule update --init --recursive"
    exit 1
fi

# Test 2: Check if Dockerfiles exist
print_status "Checking generated Dockerfiles..."
if [ -f "dockerfiles/ubuntu/24.04/Dockerfile" ]; then
    print_status "✓ Ubuntu 24.04 Dockerfile exists"
else
    print_error "✗ Ubuntu 24.04 Dockerfile not found"
    echo "Run: ./scripts/generate-dockerfiles.sh"
    exit 1
fi

# Test 3: Check if GitHub workflow exists
print_status "Checking GitHub Actions workflow..."
if [ -f ".github/workflows/ghcr-build.yml" ]; then
    print_status "✓ GHCR build workflow exists"
else
    print_error "✗ GHCR build workflow not found"
    exit 1
fi

# Test 4: Test Docker build (if Docker is available)
print_status "Testing Docker build..."
if command -v docker &> /dev/null; then
    if docker build -t skunklabz/ubuntu-24.04-runner:test dockerfiles/ubuntu/24.04/ > /dev/null 2>&1; then
        print_status "✓ Docker image builds successfully"
        
        # Test basic container functionality
        if docker run --rm --entrypoint=/bin/bash skunklabz/ubuntu-24.04-runner:test -c "which git && which curl" > /dev/null 2>&1; then
            print_status "✓ Container has required tools installed"
        else
            print_warning "⚠ Container may be missing some required tools"
        fi
        
        # Clean up test image
        docker rmi skunklabz/ubuntu-24.04-runner:test > /dev/null 2>&1
    else
        print_error "✗ Docker build failed"
        exit 1
    fi
else
    print_warning "⚠ Docker not available, skipping build test"
fi

# Test 5: Check scripts are executable
print_status "Checking script permissions..."
for script in scripts/*.sh; do
    if [ -x "$script" ]; then
        print_status "✓ $script is executable"
    else
        print_warning "⚠ $script is not executable (fixing...)"
        chmod +x "$script"
    fi
done

echo
echo "=== Validation Complete! ==="
echo
print_status "Your SkunkLabz GitHub Runner setup is ready!"
echo
echo "Next steps:"
echo "1. Commit and push your changes to GitHub"
echo "2. The workflow will automatically build and publish images to GHCR"
echo "3. Use the images in your GitHub Actions workflows"
echo
echo "Example usage in .github/workflows/your-workflow.yml:"
echo "  runs-on: ubuntu-latest"
echo "  container: ghcr.io/your-username/skunklabz-github-runner/ubuntu-24.04-runner:latest"
echo
