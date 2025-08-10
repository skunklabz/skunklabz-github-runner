#!/bin/bash

# Demo script to showcase semantic versioning functionality
# This script demonstrates how the semver system works

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

main() {
    print_header "SkunkLabz GitHub Runner - Semantic Versioning Demo"
    echo
    
    print_status "Current project version:"
    ./scripts/semver.sh get
    echo
    
    print_status "Recent git tags:"
    ./scripts/semver.sh tags
    echo
    
    print_status "What would auto-bump do? (dry-run)"
    # Show what auto-bump would do without actually doing it
    echo "  Simulating: ./scripts/semver.sh auto --dry-run --force"
    echo "  (Dry-run functionality is integrated into the script)"
    echo "  Would determine bump type based on recent commits and show new version"
    echo
    
    print_status "Available semver commands:"
    echo "  ./scripts/semver.sh get                    # Get current version"
    echo "  ./scripts/semver.sh bump patch             # Bump patch version"
    echo "  ./scripts/semver.sh bump minor             # Bump minor version"
    echo "  ./scripts/semver.sh bump major             # Bump major version"
    echo "  ./scripts/semver.sh auto                   # Auto-determine and bump"
    echo "  ./scripts/semver.sh auto --dry-run         # Preview what auto would do"
    echo "  ./scripts/semver.sh tags                   # List recent tags"
    echo
    
    print_warning "To actually bump the version, remove --dry-run or use specific bump commands"
    print_warning "Remember to commit your changes before bumping versions"
    echo
    
    print_header "Demo Complete!"
}

# Run main function
main "$@"
