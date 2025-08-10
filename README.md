# SkunkLabz GitHub Runner Images

This repository contains custom GitHub Actions runner images based on Microsoft's official runner-images repository. It automatically tracks updates from Microsoft and builds Docker images for GitHub Container Registry (GHCR).

## 🎯 Purpose

The goal is to provide pre-built, containerized GitHub Actions runners that:
- Track Microsoft's official runner-images updates automatically
- Build and publish to GitHub Container Registry
- Maintain compatibility with Microsoft's build scripts
- Provide a foundation for custom runner environments

## 🏗️ Architecture

```
skunklabz-github-runner/
├── dockerfiles/           # Generated Dockerfiles
│   └── ubuntu/
│       └── 24.04/        # Ubuntu 24.04 runner
├── runner-images/         # Microsoft's runner-images submodule
├── scripts/               # Build and generation scripts
└── .github/workflows/     # GitHub Actions workflows
```

## 🚀 Features

- **Automated Updates**: Checks for Microsoft runner-images updates every 6 hours
- **Multi-Platform Support**: Currently supports Ubuntu 24.04
- **GHCR Integration**: Automatically publishes to GitHub Container Registry
- **Submodule Tracking**: Keeps Microsoft's runner-images as a submodule
- **Customizable**: Easy to extend with additional platforms or customizations

## 📋 Prerequisites

- GitHub repository with Actions enabled
- GitHub Container Registry access
- Docker (for local testing)

## 🛠️ Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/skunklabz-github-runner.git
cd skunklabz-github-runner
```

### 2. Initialize Submodules

```bash
./scripts/init-submodule.sh
```

### 3. Generate Dockerfiles

```bash
./scripts/generate-dockerfiles.sh
```

### 4. Test the Setup

```bash
./scripts/test-setup.sh
```

## 🐳 Usage

### Using Pre-built Images

Use the images directly in your GitHub Actions workflows:

```yaml
name: My Workflow
on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    container: ghcr.io/skunklabz/skunklabz-github-runner-ubuntu-24.04:latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: |
          echo "Running on custom runner!"
          # Your workflow steps here
```

### Building Locally

```bash
# Build the Ubuntu 24.04 runner
docker build -t my-runner:latest dockerfiles/ubuntu/24.04/

# Run interactively for testing
docker run -it --rm my-runner:latest /bin/bash
```

## 🔄 Automation

The repository includes a GitHub Actions workflow (`.github/workflows/ghcr-build.yml`) that:

1. **Monitors Updates**: Checks Microsoft's runner-images repository every 6 hours
2. **Builds Images**: Automatically builds Docker images when updates are detected
3. **Publishes**: Pushes images to GitHub Container Registry
4. **Tags**: Creates appropriate tags (latest, versioned, etc.)

### Available Images

- `ghcr.io/skunklabz/skunklabz-github-runner-ubuntu-24.04:latest`
- `ghcr.io/skunklabz/skunklabz-github-runner-ubuntu-24.04:manual-{build-number}`

## 🔧 Customization

### Adding New Platforms

1. Create new directory structure under `dockerfiles/`
2. Update `scripts/generate-dockerfiles.sh` to include your platform
3. Modify `.github/workflows/ghcr-build.yml` to build the new platform

### Customizing Existing Images

1. Edit the relevant Dockerfile in `dockerfiles/`
2. Add custom scripts to the `scripts/` directory
3. Update the generation script if needed

## 📁 Project Structure

```
skunklabz-github-runner/
├── .github/
│   ├── packages.yml                    # GHCR package configuration
│   └── workflows/
│       └── ghcr-build.yml             # Main build workflow
├── dockerfiles/                        # Generated Dockerfiles
│   └── ubuntu/
│       └── 24.04/
│           ├── Dockerfile             # Ubuntu 24.04 runner
│           ├── entrypoint.sh          # Container entrypoint
│           └── scripts/               # Microsoft's build scripts
├── runner-images/                      # Microsoft's submodule
├── scripts/
│   ├── generate-dockerfiles.sh        # Generate Dockerfiles
│   ├── init-submodule.sh             # Initialize submodule
│   ├── setup.sh                      # Complete setup
│   ├── test-setup.sh                 # Validate setup
│   └── trigger-build.sh              # Manual build trigger
└── README.md
```

## 🧪 Testing

Run the validation script to ensure everything is working:

```bash
./scripts/test-setup.sh
```

This will:
- ✅ Check submodule initialization
- ✅ Validate Dockerfile generation
- ✅ Test Docker image builds
- ✅ Verify container functionality
- ✅ Check script permissions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run the test script (`./scripts/test-setup.sh`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Microsoft for the excellent [runner-images](https://github.com/actions/runner-images) repository
- GitHub Actions team for the runner architecture
- The open-source community for continuous improvements

## 🔗 Related Links

- [GitHub Actions Runner Images](https://github.com/actions/runner-images)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)