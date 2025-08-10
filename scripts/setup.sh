#!/bin/bash

# Setup script for SkunkLabz Ubuntu GitHub Runners
# This script helps set up the initial repository configuration

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

# Check if submodule already exists
check_submodule() {
    if [ -d "runner-images" ]; then
        print_warning "Submodule 'runner-images' already exists"
        read -p "Do you want to remove it and re-add? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Removing existing submodule..."
            git submodule deinit -f runner-images
            git rm -f runner-images
            rm -rf .git/modules/runner-images
        else
            print_status "Keeping existing submodule"
            return 0
        fi
    fi
}

# Add the submodule
add_submodule() {
    print_status "Adding Microsoft runner-images as submodule..."
    git submodule add https://github.com/actions/runner-images.git
    git submodule update --init --recursive
}

# Configure git user if not set
configure_git() {
    if [ -z "$(git config user.name)" ] || [ -z "$(git config user.email)" ]; then
        print_warning "Git user configuration not set"
        read -p "Would you like to configure git user now? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Enter your name: " GIT_NAME
            read -p "Enter your email: " GIT_EMAIL
            git config user.name "$GIT_NAME"
            git config user.email "$GIT_EMAIL"
            print_status "Git user configured"
        fi
    fi
}

# Make scripts executable
make_scripts_executable() {
    print_status "Making scripts executable..."
    chmod +x scripts/*.sh
}

# Show next steps
show_next_steps() {
    print_header "Setup Complete!"
    echo
    print_status "Next steps:"
    echo "1. Configure GitHub Secrets in your repository:"
    echo "   - Go to Settings > Secrets and variables > Actions"
    echo "   - Add DOCKER_USERNAME and DOCKER_PASSWORD"
    echo
    echo "2. Commit and push your changes:"
    echo "   git add ."
    echo "   git commit -m 'Initial setup with runner-images submodule'"
    echo "   git push origin main"
    echo
    echo "3. The workflows will automatically start running"
    echo
    print_status "Your repository is now configured to automatically build GitHub runners!"
}

# Main execution
main() {
    print_header "SkunkLabz Ubuntu GitHub Runners Setup"
    echo
    
    check_git_repo
    configure_git
    check_submodule
    add_submodule
    make_scripts_executable
    
    print_status "Committing submodule configuration..."
    git add .gitmodules runner-images
    git commit -m "Add runner-images submodule" || {
        print_warning "No changes to commit (submodule may already be configured)"
    }
    
    show_next_steps
}

# Run main function
main "$@"
