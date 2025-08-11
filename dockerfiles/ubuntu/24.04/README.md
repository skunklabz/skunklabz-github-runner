# Ubuntu 24.04 GitHub Actions Runner with Auto-Configuration

This Docker image provides a GitHub Actions runner based on Ubuntu 24.04 with automatic configuration support.

## Features

- **Auto-Configuration**: Automatically configures the runner using environment variables
- **Standard GitHub Actions Runner**: Based on Microsoft's official runner-images
- **Ubuntu 24.04**: Latest LTS release with all necessary dependencies

## Usage

### Auto-Configuration (Recommended)

The runner will automatically configure itself if the following environment variables are provided:

```bash
docker run -d \
  -e GITHUB_URL="https://github.com/your-org/your-repo" \
  -e GITHUB_TOKEN="your-registration-token" \
  ghcr.io/skunklabz/skunklabz-github-runner-ubuntu-24.04:latest
```

**Required Environment Variables:**
- `GITHUB_URL`: The GitHub repository or organization URL
- `GITHUB_TOKEN`: A GitHub registration token (not a PAT)

### Manual Configuration

If you prefer to configure manually or don't provide the environment variables:

```bash
docker run -it --rm \
  ghcr.io/skunklabz/skunklabz-github-runner-ubuntu-24.04:latest

# Inside the container:
./config.sh --url https://github.com/your-org/your-repo --token YOUR_TOKEN
./run.sh
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `GITHUB_URL` | Yes* | GitHub repository or organization URL |
| `GITHUB_TOKEN` | Yes* | GitHub registration token |
| `RUNNER_VERSION` | No | GitHub Actions runner version (default: 2.311.0) |

*Required for auto-configuration

## Building

```bash
cd dockerfiles/ubuntu/24.04
docker build -t skunklabz-github-runner:ubuntu-24.04 .
```

## Testing

Test the auto-configuration logic:

```bash
docker run --rm skunklabz-github-runner:ubuntu-24.04 ./test-config.sh
```

## How Auto-Configuration Works

1. Container starts and checks for `.runner` file
2. If not configured, checks for `GITHUB_URL` and `GITHUB_TOKEN` environment variables
3. If both are present, automatically runs `./config.sh` with the provided values
4. Starts the runner with `./run.sh`
5. If environment variables are missing, falls back to manual configuration mode

## Troubleshooting

- **"Runner not configured"**: Ensure `GITHUB_URL` and `GITHUB_TOKEN` are set correctly
- **"Failed to configure runner"**: Check that the registration token is valid and not expired
- **Permission denied**: Ensure the container has write access to the runner directory
