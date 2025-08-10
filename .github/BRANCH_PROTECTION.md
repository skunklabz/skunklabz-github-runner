# Branch Protection Configuration

This document outlines the recommended branch protection settings for the `main` branch of the skunklabz-github-runner repository.

## 🛡️ Current Status

As of the last check, the `main` branch has **no protection rules** enabled. This document provides the recommended configuration.

## 📋 Recommended Branch Protection Rules

### Required Settings

Navigate to: **Settings → Branches → Add rule** (or edit existing rule for `main`)

#### Branch Name Pattern
```
main
```

#### Protection Rules

**✅ Restrict pushes that create files**
- [ ] Restrict pushes that create files larger than 100 MB

**✅ Require a pull request before merging**
- [x] Require approvals: **1**
- [x] Dismiss stale pull request approvals when new commits are pushed
- [x] Require review from code owners (when CODEOWNERS file exists)
- [x] Restrict pushes that create files larger than specified limit

**✅ Require status checks to pass before merging**
- [x] Require branches to be up to date before merging
- Required status checks (add when CI/CD is configured):
  - `build-and-test`
  - `docker-build`
  - `security-scan`

**✅ Require conversation resolution before merging**
- [x] Require conversation resolution before merging

**✅ Require signed commits**
- [x] Require signed commits

**✅ Require linear history**
- [x] Require linear history

**✅ Include administrators**
- [x] Include administrators (applies rules to admins too)

**❌ Allow force pushes**
- [ ] Allow force pushes (disabled for security)

**❌ Allow deletions**
- [ ] Allow deletions (disabled for security)

## 🔧 Manual Configuration Steps

Since branch protection must be configured through the GitHub web interface:

### Step 1: Navigate to Settings
1. Go to the repository: https://github.com/skunklabz/skunklabz-github-runner
2. Click on **Settings** tab
3. Select **Branches** from the left sidebar

### Step 2: Add Protection Rule
1. Click **Add rule** button
2. Enter `main` as the branch name pattern
3. Configure the settings as outlined above

### Step 3: Save Configuration
1. Review all settings
2. Click **Create** to save the protection rule

## 🚀 Advanced Configuration (Optional)

### Status Checks (Future)
When CI/CD workflows are added, enable these status checks:

```yaml
# Example GitHub Actions workflow names to require
- "Build and Test"
- "Docker Build"
- "Security Scan"
- "Lint and Format"
```

### Code Owners (Future)
Create a `.github/CODEOWNERS` file to automatically request reviews:

```
# Global owners
* @skunklabz

# Docker and build files
dockerfiles/ @skunklabz
scripts/ @skunklabz
.github/workflows/ @skunklabz

# Documentation
*.md @skunklabz
docs/ @skunklabz
```

## 🔍 Verification

After configuring branch protection, verify by:

1. **Testing Pull Request Flow**:
   - Create a feature branch
   - Make a small change
   - Open a pull request
   - Verify approval is required

2. **Testing Direct Push Prevention**:
   - Try to push directly to main (should fail)
   - Confirm error message mentions branch protection

3. **Review Protection Status**:
   - Check that the branch shows as "Protected" in the branches list
   - Verify all rules are active in Settings → Branches

## 📚 Benefits of Branch Protection

With these rules enabled:

- ✅ **Prevents accidental direct pushes** to main branch
- ✅ **Requires code review** for all changes
- ✅ **Ensures CI/CD passes** before merging
- ✅ **Maintains clean git history** with linear commits
- ✅ **Requires signed commits** for authenticity
- ✅ **Forces conversation resolution** before merging
- ✅ **Applies rules to all users** including administrators

## 🆘 Troubleshooting

### Common Issues

**Issue**: Can't push to main branch
**Solution**: Create a feature branch and open a pull request

**Issue**: PR can't be merged
**Solution**: Ensure all status checks pass and required approvals are obtained

**Issue**: Force push blocked
**Solution**: This is intentional; use proper git workflow with feature branches

### Emergency Override

In emergency situations, administrators can temporarily:
1. Go to Settings → Branches
2. Edit the protection rule
3. Temporarily disable specific requirements
4. **Remember to re-enable after emergency**

---

**Note**: Branch protection rules help maintain code quality and prevent accidental changes to the main branch. These settings align with best practices for open-source projects.