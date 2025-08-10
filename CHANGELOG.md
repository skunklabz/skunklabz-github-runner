# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-10

### Added
- Add package configuration for GitHub Container Registry
- Add GHCR workflow for building and pushing Docker images to GitHub Container Registry
- Add Dockerfile generation step to all workflows
- Add .gitignore to ignore submodule changes
- Add runner-images subproject

### Changed
- Remove update-submodule job from workflow
- Update README to include GHCR workflow information and usage instructions
- Restructure to use own Dockerfile directory instead of modifying submodule

### Fixed
- Fix GHCR permissions and image naming

### Other
- git statusComplete GitHub runner setup with automated GHCR builds
- Initial commit
- Initial commit\n
### Infrastructure
- Updated to Microsoft runner-images commit: `--dry-run`

[1.0.0]: https://github.com/skunklabz/skunklabz-github-runner/releases/tag/v1.0.0
