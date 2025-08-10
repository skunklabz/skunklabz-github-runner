# Security Policy

## Supported Versions

We actively maintain and provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| latest  | ✅ Yes             |
| main    | ✅ Yes             |

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

### 🔒 Private Disclosure

For security issues, please **DO NOT** create a public GitHub issue. Instead:

1. **Email**: Send details to [ken@godoy.cc](mailto:ken@godoy.cc)
2. **Subject**: Use "SECURITY: SkunkLabz GitHub Runner - [Brief Description]"
3. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact assessment
   - Any suggested fixes (if available)

### ⏱️ Response Timeline

- **Initial Response**: Within 48 hours of report
- **Assessment**: Within 1 week of initial response
- **Fix Timeline**: Depends on severity and complexity
- **Public Disclosure**: After fix is released and users have time to update

### 🛡️ Security Best Practices

When using this project:

#### Container Security
- Always use the latest published images
- Scan containers for vulnerabilities before deployment
- Use specific version tags rather than `latest` in production
- Implement proper container runtime security

#### GitHub Actions Security
- Review all workflow files before use
- Use pinned action versions (not `@main` or `@master`)
- Limit repository secrets and permissions
- Monitor workflow runs for suspicious activity

#### Infrastructure Security
- Keep Docker and container runtime updated
- Use network policies to isolate containers
- Implement proper logging and monitoring
- Regular security audits of deployed runners

### 🔄 Security Updates

Security updates will be:
- Released as soon as possible after verification
- Documented in [CHANGELOG.md](CHANGELOG.md)
- Announced via GitHub releases
- Tagged appropriately for easy identification

### 📋 Known Security Considerations

This project inherits security considerations from:
- Microsoft's runner-images (upstream dependency)
- Docker containerization
- GitHub Actions runtime environment

Users should:
- Regularly update to latest versions
- Monitor security advisories for dependencies
- Follow container security best practices
- Implement appropriate network and access controls

---

Thank you for helping keep SkunkLabz GitHub Runner Images secure! 🔒