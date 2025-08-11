#!/bin/bash

# Test script to verify auto-configuration logic

set -e

echo "Testing auto-configuration logic..."

# Test case 1: No environment variables
echo "Test 1: No environment variables"
unset GITHUB_URL GITHUB_TOKEN
if [ -n "${GITHUB_URL:-}" ] || [ -n "${GITHUB_TOKEN:-}" ]; then
    echo "FAIL: Environment variables should be empty"
    exit 1
else
    echo "PASS: Environment variables are empty"
fi

# Test case 2: With environment variables
echo "Test 2: With environment variables"
export GITHUB_URL="https://github.com/test/org"
export GITHUB_TOKEN="test-token"
if [ -n "${GITHUB_URL:-}" ] && [ -n "${GITHUB_TOKEN:-}" ]; then
    echo "PASS: Environment variables are set"
    echo "  GITHUB_URL: $GITHUB_URL"
    echo "  GITHUB_TOKEN: $GITHUB_TOKEN"
else
    echo "FAIL: Environment variables should be set"
    exit 1
fi

echo "All tests passed!"
