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
