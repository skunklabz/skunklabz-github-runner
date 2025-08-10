# Contributing to SkunkLabz GitHub Runner Images

Thank you for your interest in contributing to this project! This repository provides custom GitHub Actions runner images with automated tracking of Microsoft's runner-images.

## 🤝 How to Contribute

### Reporting Issues

If you encounter any problems or have suggestions:

1. Check existing [issues](https://github.com/skunklabz/skunklabz-github-runner/issues) first
2. Create a new issue with:
   - Clear description of the problem or suggestion
   - Steps to reproduce (if applicable)
   - Expected vs actual behavior
   - Environment details (OS, Docker version, etc.)

### Code Contributions

1. **Fork** the repository
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/your-username/skunklabz-github-runner.git
   cd skunklabz-github-runner
   ```

3. **Set up** the development environment:
   ```bash
   ./scripts/setup.sh
   ```

4. **Create** a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

5. **Make** your changes following our guidelines below

6. **Test** your changes:
   ```bash
   ./scripts/test-setup.sh
   ```

7. **Commit** your changes:
   ```bash
   git commit -m "Add: brief description of your changes"
   ```

8. **Push** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

9. **Create** a Pull Request with:
   - Clear title and description
   - Reference to related issues
   - Screenshots/logs if applicable

## 📋 Development Guidelines

### Code Style

- Use descriptive variable and function names
- Add comments for complex logic
- Follow existing patterns in the codebase
- Ensure scripts are executable (`chmod +x`)

### Testing Requirements

All contributions must:
- ✅ Pass the validation script (`./scripts/test-setup.sh`)
- ✅ Build Docker images successfully
- ✅ Not break existing functionality
- ✅ Include appropriate error handling

### Commit Message Format

Use clear, descriptive commit messages:
- `Add: new feature or functionality`
- `Fix: bug fixes`
- `Update: changes to existing features`
- `Docs: documentation updates`
- `Refactor: code improvements without functional changes`

## 🏗️ Project Structure

Understanding the project layout:

```
skunklabz-github-runner/
├── .github/              # GitHub-specific files
├── dockerfiles/          # Generated Docker configurations
├── runner-images/        # Microsoft's submodule (DO NOT MODIFY)
├── scripts/              # Build and utility scripts
└── docs/                 # Additional documentation
```

### Key Files

- `scripts/generate-dockerfiles.sh` - Generates Docker configurations
- `scripts/setup.sh` - Complete project setup
- `scripts/test-setup.sh` - Validation and testing
- `.github/workflows/` - CI/CD automation

## 🚫 Important Notes

- **DO NOT** modify files in the `runner-images/` directory (it's a submodule)
- **DO NOT** commit sensitive information (tokens, passwords, etc.)
- **DO** test your changes thoroughly before submitting
- **DO** update documentation if you change functionality

## 🆘 Getting Help

- Check the [README](README.md) for setup instructions
- Review existing [issues](https://github.com/skunklabz/skunklabz-github-runner/issues)
- Look at the [project structure](#-project-structure) above
- Run `./scripts/test-setup.sh` to validate your environment

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the same [MIT License](LICENSE) that covers the project.

---

Thank you for contributing to SkunkLabz GitHub Runner Images! 🎉