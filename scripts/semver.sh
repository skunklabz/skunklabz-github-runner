#!/bin/bash

# Semantic Versioning Script for SkunkLabz GitHub Runner
# This script handles version bumping, tagging, and release management

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

# Get the current version from VERSION file
get_current_version() {
    if [ -f "VERSION" ]; then
        cat VERSION | tr -d '\n'
    else
        echo "0.0.0"
    fi
}

# Parse version into components
parse_version() {
    local version="$1"
    echo "$version" | sed 's/v//' | tr '.' ' '
}

# Increment version based on type
increment_version() {
    local current_version="$1"
    local bump_type="$2"
    
    # Parse current version
    read -r major minor patch <<< "$(parse_version "$current_version")"
    
    case "$bump_type" in
        "major")
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        "minor")
            minor=$((minor + 1))
            patch=0
            ;;
        "patch")
            patch=$((patch + 1))
            ;;
        *)
            print_error "Invalid bump type: $bump_type. Use: major, minor, patch"
            exit 1
            ;;
    esac
    
    echo "${major}.${minor}.${patch}"
}

# Determine version bump type based on changes
determine_bump_type() {
    local last_tag="$1"
    
    # Get commits since last tag
    if [ -n "$last_tag" ]; then
        commits=$(git log --oneline "${last_tag}..HEAD" --format="%s")
    else
        commits=$(git log --oneline --format="%s")
    fi
    
    # Check for breaking changes (MAJOR)
    if echo "$commits" | grep -qiE "(breaking|major|BREAKING CHANGE)"; then
        echo "major"
        return
    fi
    
    # Check for new features (MINOR)
    if echo "$commits" | grep -qiE "(feat|feature|add|new)"; then
        echo "minor"
        return
    fi
    
    # Default to patch for fixes, updates, etc.
    echo "patch"
}

# Get the last git tag
get_last_tag() {
    git tag --sort=-version:refname | head -n1 2>/dev/null || echo ""
}

# Create a new version tag
create_tag() {
    local version="$1"
    local message="$2"
    
    # Create annotated tag
    git tag -a "v${version}" -m "${message}"
    print_status "Created tag: v${version}"
}

# Generate changelog for the version
generate_changelog() {
    local last_tag="$1"
    local new_version="$2"
    local runner_commit="$3"
    
    local changelog_file="CHANGELOG.md"
    local temp_file=$(mktemp)
    
    # Create header for new version
    echo "# Changelog" > "$temp_file"
    echo "" >> "$temp_file"
    echo "All notable changes to this project will be documented in this file." >> "$temp_file"
    echo "" >> "$temp_file"
    echo "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)," >> "$temp_file"
    echo "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)." >> "$temp_file"
    echo "" >> "$temp_file"
    
    # Add new version entry
    echo "## [${new_version}] - $(date +%Y-%m-%d)" >> "$temp_file"
    echo "" >> "$temp_file"
    
    # Get commits since last tag
    if [ -n "$last_tag" ]; then
        commits=$(git log --oneline "${last_tag}..HEAD" --format="- %s")
    else
        commits=$(git log --oneline --format="- %s")
    fi
    
    # Categorize commits
    local added=""
    local changed=""
    local fixed=""
    local other=""
    
    while IFS= read -r commit; do
        if echo "$commit" | grep -qiE "(feat|feature|add|new)"; then
            added="${added}${commit}\n"
        elif echo "$commit" | grep -qiE "(fix|bug|patch)"; then
            fixed="${fixed}${commit}\n"
        elif echo "$commit" | grep -qiE "(update|change|modify)"; then
            changed="${changed}${commit}\n"
        else
            other="${other}${commit}\n"
        fi
    done <<< "$commits"
    
    # Add sections to changelog
    if [ -n "$added" ]; then
        echo "### Added" >> "$temp_file"
        echo -e "$added" >> "$temp_file"
    fi
    
    if [ -n "$changed" ]; then
        echo "### Changed" >> "$temp_file"
        echo -e "$changed" >> "$temp_file"
    fi
    
    if [ -n "$fixed" ]; then
        echo "### Fixed" >> "$temp_file"
        echo -e "$fixed" >> "$temp_file"
    fi
    
    if [ -n "$other" ]; then
        echo "### Other" >> "$temp_file"
        echo -e "$other" >> "$temp_file"
    fi
    
    # Add runner-images info if provided
    if [ -n "$runner_commit" ]; then
        echo "### Infrastructure" >> "$temp_file"
        echo "- Updated to Microsoft runner-images commit: \`${runner_commit}\`" >> "$temp_file"
        echo "" >> "$temp_file"
    fi
    
    # Append existing changelog if it exists
    if [ -f "$changelog_file" ]; then
        # Skip the header from existing changelog
        tail -n +8 "$changelog_file" >> "$temp_file" 2>/dev/null || true
    fi
    
    # Replace the original changelog
    mv "$temp_file" "$changelog_file"
    
    print_status "Updated changelog: $changelog_file"
}

# Main version bump function
bump_version() {
    local bump_type="$1"
    local runner_commit="$2"
    local force_or_dry="${3:-false}"
    local dry_run="false"
    local force="false"
    
    # Parse force/dry-run options
    for arg in "$3" "$4" "$5"; do
        case "$arg" in
            "--dry-run")
                dry_run="true"
                ;;
            "--force")
                force="true"
                ;;
        esac
    done
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        exit 1
    fi
    
    # Check for uncommitted changes (skip in dry-run)
    if [ "$force" != "true" ] && [ "$dry_run" != "true" ] && ! git diff-index --quiet HEAD --; then
        print_error "You have uncommitted changes. Commit them first or use --force"
        exit 1
    fi
    
    # Get current version and last tag
    local current_version
    current_version=$(get_current_version)
    local last_tag
    last_tag=$(get_last_tag)
    
    print_status "Current version: $current_version"
    print_status "Last tag: ${last_tag:-none}"
    
    # Auto-determine bump type if not provided
    if [ -z "$bump_type" ]; then
        bump_type=$(determine_bump_type "$last_tag")
        print_status "Auto-determined bump type: $bump_type"
    fi
    
    # Calculate new version
    local new_version
    new_version=$(increment_version "$current_version" "$bump_type")
    
    print_status "New version: $new_version"
    
    # If dry-run, just output the new version and exit
    if [ "$dry_run" == "true" ]; then
        print_status "Dry-run mode: would bump to v${new_version}"
        echo "$new_version"
        return 0
    fi
    
    # Update VERSION file
    echo "$new_version" > VERSION
    
    # Generate changelog
    generate_changelog "$last_tag" "$new_version" "$runner_commit"
    
    # Stage changes
    git add VERSION CHANGELOG.md
    
    # Create commit message
    local commit_msg="chore: bump version to v${new_version}"
    if [ -n "$runner_commit" ]; then
        commit_msg="${commit_msg} (runner-images: ${runner_commit})"
    fi
    
    # Commit changes
    git commit -m "$commit_msg"
    
    # Create tag
    local tag_msg="Release v${new_version}"
    if [ -n "$runner_commit" ]; then
        tag_msg="${tag_msg} - Updated to Microsoft runner-images ${runner_commit}"
    fi
    
    create_tag "$new_version" "$tag_msg"
    
    print_header "Version Bump Complete!"
    print_status "Version: v${new_version}"
    print_status "Tag: v${new_version}"
    print_status "Don't forget to push: git push origin main --tags"
    
    echo "$new_version"
}

# Get version for automation
get_version() {
    get_current_version
}

# List recent tags
list_tags() {
    print_header "Recent Tags"
    git tag --sort=-version:refname | head -10 || echo "No tags found"
}

# Show help
show_help() {
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  bump <type> [runner-commit] [--force]  Bump version (major|minor|patch)"
    echo "  auto [runner-commit] [--force]         Auto-determine and bump version"
    echo "  get                                    Get current version"
    echo "  tags                                   List recent tags"
    echo "  help                                   Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 bump patch                          Bump patch version"
    echo "  $0 bump minor abc123                   Bump minor with runner commit"
    echo "  $0 bump patch --dry-run                Show what version would be bumped to"
    echo "  $0 auto                                Auto-bump based on commits"
    echo "  $0 auto --dry-run                      Show what auto-bump would do"
    echo "  $0 get                                 Show current version"
}

# Main script logic
main() {
    case "${1:-help}" in
        "bump")
            if [ -z "$2" ]; then
                print_error "Bump type required: major, minor, patch"
                exit 1
            fi
            bump_version "$2" "$3" "$4"
            ;;
        "auto")
            bump_version "" "$2" "$3"
            ;;
        "get")
            get_version
            ;;
        "tags")
            list_tags
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Run main function
main "$@"
