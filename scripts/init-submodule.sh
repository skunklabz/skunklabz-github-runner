#!/bin/bash

# Script to initialize the runner-images submodule
# This is useful if the submodule is missing or not properly initialized

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Check if we're in a git repository
check_git_repo() {
    if [ ! -d ".git" ]; then
        print_error "This script must be run from a git repository root"
        exit 1
    fi
}

# Check if submodule exists and is properly configured
check_submodule() {
    if [ -f ".gitmodules" ]; then
        print_status "Found .gitmodules file"
        cat .gitmodules
    else
        print_error ".gitmodules file not found"
        exit 1
    fi
    
    if [ -d "runner-images" ]; then
        print_status "runner-images directory exists"
        if [ -d "runner-images/.git" ]; then
            print_status "Submodule appears to be initialized"
            return 0
        else
            print_warning "runner-images directory exists but is not a git repository"
            return 1
        fi
    else
        print_warning "runner-images directory not found"
        return 1
    fi
}

# Initialize the submodule
init_submodule() {
    print_status "Initializing submodule..."
    
    # Remove existing directory if it's not a proper submodule
    if [ -d "runner-images" ] && [ ! -d "runner-images/.git" ]; then
        print_warning "Removing invalid runner-images directory..."
        rm -rf runner-images
    fi
    
    # Initialize and update submodule
    git submodule update --init --recursive
    
    print_status "Submodule initialized successfully!"
}

# Verify the submodule structure
verify_structure() {
    print_status "Verifying submodule structure..."
    
    if [ ! -d "runner-images" ]; then
        print_error "runner-images directory not found after initialization"
        exit 1
    fi
    
    if [ ! -d "runner-images/images" ]; then
        print_error "images directory not found in submodule"
        exit 1
    fi
    
    if [ ! -d "runner-images/images/ubuntu" ]; then
        print_error "ubuntu directory not found in submodule"
        exit 1
    fi
    
    print_status "✓ Submodule structure verified!"
    echo "Available Ubuntu versions:"
    ls -la runner-images/images/ubuntu/
}

# Show submodule status
show_status() {
    print_status "Current submodule status:"
    git submodule status
    
    print_status "Submodule remote information:"
    cd runner-images
    git remote -v
    git branch -a
    cd ..
}

# Main execution
main() {
    print_header "Runner Images Submodule Initialization"
    echo
    
    check_git_repo
    
    if check_submodule; then
        print_status "Submodule appears to be properly configured"
        show_status
    else
        print_status "Submodule needs initialization"
        init_submodule
    fi
    
    verify_structure
    show_status
    
    print_header "Initialization Complete!"
    echo
    print_status "The runner-images submodule is now properly initialized."
    print_status "You can now run your GitHub Actions workflows."
    echo
    print_status "To test the setup, run:"
    echo "  ./scripts/test.yml"
    echo "  # or push to trigger the test workflow"
}

# Run main function
main "$@"
