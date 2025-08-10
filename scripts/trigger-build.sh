#!/bin/bash

# Script to trigger a build when Microsoft updates their runner-images
# This can be used in webhooks, cron jobs, or manually

set -e

# Configuration
GITHUB_TOKEN="${GITHUB_TOKEN}"
REPO="skunklabz/skunklabz-ubuntu-runners"
WORKFLOW="webhook-trigger.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Check if GitHub token is set
if [ -z "$GITHUB_TOKEN" ]; then
    print_error "GITHUB_TOKEN environment variable is not set"
    print_error "Please set it with: export GITHUB_TOKEN=your_token_here"
    exit 1
fi

# Function to get latest commit from Microsoft runner-images
get_latest_commit() {
    print_status "Fetching latest commit from Microsoft runner-images..."
    
    # Get the latest commit SHA from Microsoft's main branch
    LATEST_COMMIT=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/actions/runner-images/branches/main" | \
        jq -r '.commit.sha')
    
    if [ "$LATEST_COMMIT" = "null" ] || [ -z "$LATEST_COMMIT" ]; then
        print_error "Failed to get latest commit from Microsoft repository"
        exit 1
    fi
    
    print_status "Latest commit: $LATEST_COMMIT"
    echo "$LATEST_COMMIT"
}

# Function to trigger GitHub Actions workflow
trigger_workflow() {
    local commit_sha="$1"
    
    print_status "Triggering workflow: $WORKFLOW"
    print_status "Commit SHA: $commit_sha"
    
    # Trigger the workflow using GitHub API
    RESPONSE=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/$REPO/dispatches" \
        -d "{
            \"event_type\": \"runner-images-updated\",
            \"client_payload\": {
                \"commit_sha\": \"$commit_sha\"
            }
        }")
    
    if [ $? -eq 0 ]; then
        print_status "Workflow triggered successfully!"
        print_status "Check the Actions tab in your repository: https://github.com/$REPO/actions"
    else
        print_error "Failed to trigger workflow"
        print_error "Response: $RESPONSE"
        exit 1
    fi
}

# Function to check if we need to build
check_and_build() {
    print_status "Checking if build is needed..."
    
    # Get latest commit from Microsoft
    LATEST_COMMIT=$(get_latest_commit)
    
    # Check if we already have this commit built
    # This is a simple check - you might want to enhance this
    if [ -f ".last_built_commit" ]; then
        LAST_BUILT=$(cat .last_built_commit)
        if [ "$LATEST_COMMIT" = "$LAST_BUILT" ]; then
            print_status "No new commits to build. Latest: $LATEST_COMMIT"
            return 0
        fi
    fi
    
    print_status "New commit detected. Triggering build..."
    trigger_workflow "$LATEST_COMMIT"
    
    # Save the commit we just built
    echo "$LATEST_COMMIT" > .last_built_commit
}

# Main execution
main() {
    print_status "Starting runner build trigger script..."
    
    case "${1:-check}" in
        "check")
            check_and_build
            ;;
        "force")
            print_warning "Force triggering build..."
            LATEST_COMMIT=$(get_latest_commit)
            trigger_workflow "$LATEST_COMMIT"
            ;;
        "help"|"-h"|"--help")
            echo "Usage: $0 [check|force|help]"
            echo ""
            echo "Commands:"
            echo "  check  - Check for updates and build if needed (default)"
            echo "  force  - Force trigger a build with latest commit"
            echo "  help   - Show this help message"
            echo ""
            echo "Environment variables:"
            echo "  GITHUB_TOKEN - Your GitHub personal access token"
            ;;
        *)
            print_error "Unknown command: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
    
    print_status "Script completed successfully!"
}

# Run main function with all arguments
main "$@"
