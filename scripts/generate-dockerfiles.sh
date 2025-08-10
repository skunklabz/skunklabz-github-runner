#!/bin/bash

# Script to generate Dockerfiles based on Microsoft's runner-images structure
# This adapts to their new Packer-based approach by creating Dockerfiles from their scripts

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

# Check if we're in the right directory
check_directory() {
    if [ ! -d "runner-images" ]; then
        print_error "runner-images directory not found. Run this from the repository root."
        exit 1
    fi
    
    if [ ! -d "runner-images/images/ubuntu" ]; then
        print_error "Ubuntu images directory not found in submodule."
        exit 1
    fi
}

# Create Dockerfile for Ubuntu 24.04
create_ubuntu_2404_dockerfile() {
    print_status "Creating Dockerfile for Ubuntu 24.04..."
    
    cat > dockerfiles/ubuntu/24.04/Dockerfile << 'EOF'
# Ubuntu 24.04 GitHub Actions Runner
# Based on Microsoft's runner-images build scripts

FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_VERSION=2.311.0
ENV RUNNER_ARCH=x64
ENV RUNNER_TARBALL_URL=https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz

# Install essential packages
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    jq \
    lsb-release \
    software-properties-common \
    sudo \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create runner user
RUN useradd -m -s /bin/bash runner && \
    echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to runner user
USER runner
WORKDIR /home/runner

# Download and install GitHub Actions Runner
RUN curl -o actions-runner.tar.gz -L ${RUNNER_TARBALL_URL} && \
    tar xzf ./actions-runner.tar.gz && \
    rm ./actions-runner.tar.gz

# Switch to root to run installdependencies.sh
USER root
RUN ./bin/installdependencies.sh

# Switch back to runner user
USER runner

# Copy Microsoft's build scripts for reference
COPY --chown=runner:runner scripts/ /home/runner/scripts/

# Set up entrypoint
COPY --chown=runner:runner entrypoint.sh /home/runner/entrypoint.sh
RUN chmod +x /home/runner/entrypoint.sh

ENTRYPOINT ["/home/runner/entrypoint.sh"]
CMD ["bash"]
EOF

    print_status "✓ Dockerfile for Ubuntu 24.04 created"
}

# Create entrypoint script
create_entrypoint() {
    print_status "Creating entrypoint script..."
    
    cat > dockerfiles/ubuntu/24.04/entrypoint.sh << 'EOF'
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
EOF

    chmod +x dockerfiles/ubuntu/24.04/entrypoint.sh
    print_status "✓ Entrypoint script created"
}

# Create version directories
create_version_directories() {
    print_status "Creating version directories..."
    
    mkdir -p dockerfiles/ubuntu/24.04
    
    # Copy scripts to the version directory
    if [ -d "runner-images/images/ubuntu/scripts" ]; then
        cp -r runner-images/images/ubuntu/scripts dockerfiles/ubuntu/24.04/
        print_status "✓ Scripts copied to version directory"
    else
        print_warning "No scripts directory found in runner-images, creating empty one"
        mkdir -p dockerfiles/ubuntu/24.04/scripts
    fi
    
    print_status "✓ Version directories created"
}

# Main execution
main() {
    print_header "Generating Dockerfiles from Microsoft's Runner Images"
    echo
    
    check_directory
    
    # Create version directories first
    create_version_directories
    
    # Create entrypoint script
    create_entrypoint
    
    # Create Dockerfile
    create_ubuntu_2404_dockerfile
    
    print_header "Generation Complete!"
    echo
    print_status "Dockerfile has been created in:"
    echo "  - dockerfiles/ubuntu/24.04/Dockerfile"
    echo
    print_status "You can now build the image:"
    echo "  docker build -t skunklabz/ubuntu-24.04-runner:latest dockerfiles/ubuntu/24.04/"
    echo
    print_status "Note: These are basic Dockerfiles. You may want to customize them"
    print_status "based on your specific needs and Microsoft's build scripts."
}

# Run main function
main "$@"
