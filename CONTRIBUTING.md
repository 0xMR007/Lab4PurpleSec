# Contributing to Lab4PurpleSec

Thank you for your interest in contributing to **Lab4PurpleSec**! This document provides guidelines and instructions for contributing to this open-source cybersecurity homelab project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Issues

If you find a bug, have a suggestion, or want to request a feature:

1. **Check existing issues** to avoid duplicates
2. **Use the appropriate issue template** (Bug Report, Feature Request, Documentation)
3. **Provide clear information**:
   - Description of the issue/feature
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Environment details (OS, hypervisor, versions)
   - Screenshots if applicable

### Contributing Code

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** following the project's coding standards
4. **Test your changes** thoroughly
5. **Commit your changes** with clear, descriptive messages:
   ```bash
   git commit -m "Add: Description of your change"
   ```
6. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request** with a clear description of your changes

### Contributing Documentation

Documentation improvements are always welcome! This includes:

- Fixing typos or grammatical errors
- Clarifying unclear instructions
- Adding missing information
- Improving structure and organization
- Translating documentation (if you want to add another language)

**Guidelines:**

- Follow the existing documentation style
- Use clear, concise language
- Include code examples where relevant
- Add screenshots for complex procedures
- Keep formatting consistent

### Contributing Configuration Files

If you have improved configurations:

- Test them thoroughly in an isolated environment
- Document any customizations
- Explain the purpose and benefits
- Ensure no sensitive data is included

## Development Guidelines

### Code Style

- **Bash scripts**: Follow shellcheck recommendations
- **Markdown**: Use consistent formatting, proper heading hierarchy
- **Comments**: Write clear, explanatory comments
- **Naming**: Use descriptive, self-documenting names

### Commit Messages

Use clear, descriptive commit messages:

```
Add: Feature description
Fix: Bug description
Update: What was updated
Docs: Documentation change
Refactor: Code improvement
```

### Testing

Before submitting:

- ✅ Test your changes in a clean environment
- ✅ Verify all links and references work
- ✅ Check for typos and formatting issues
- ✅ Ensure compatibility with existing setup

## Documentation Standards

### Markdown Files

- Use proper heading hierarchy (H1 → H2 → H3)
- Include table of contents for long documents
- Use code blocks with language specification
- Add screenshots where helpful
- Keep line length reasonable (80-100 characters)

### Code Blocks

Always specify the language:

````markdown
```bash
sudo systemctl restart networking
```

```yaml
version: "3"
services: ...
```
````

### Images

- Place images in `/assets/images/`
- Use descriptive filenames
- Reference with absolute paths: `/assets/images/...`
- Optimize file sizes when possible

## Pull Request Process

1. **Update documentation** if your changes affect user-facing features
2. **Update CHANGELOG.md** (if it exists) with your changes
3. **Ensure all checks pass** (linting, tests if applicable)
4. **Request review** from maintainers
5. **Respond to feedback** promptly and professionally

### PR Description Template

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Configuration improvement
- [ ] Other (please describe)

## Testing

How was this tested?

## Checklist

- [ ] Code follows project style guidelines
- [ ] Documentation updated
- [ ] No sensitive data included
- [ ] Tested in isolated environment
```

## Areas for Contribution

We welcome contributions in these areas:

### High Priority

- **Documentation improvements** - Clarity, completeness, examples
- **Bug fixes** - Installation issues, configuration problems
- **Script enhancements** - Error handling, new features
- **Test procedures** - Additional verification steps

### Medium Priority

- **New vulnerable applications** - Additional OWASP apps
- **Configuration templates** - Alternative setups
- **Automation scripts** - IaC, deployment automation
- **Translation** - Additional language support

### Low Priority

- **UI/UX improvements** - Documentation formatting
- **Performance optimizations** - Script efficiency
- **Code refactoring** - Cleanup and organization

## Security Considerations

When contributing:

- ⚠️ **Never include sensitive data** (passwords, keys, tokens)
- ⚠️ **Test in isolated environments only**
- ⚠️ **Review security implications** of your changes

## Getting Help

If you need help:

1. Check existing documentation
2. Search existing issues
3. Open a discussion/question issue
4. Contact maintainers (if contact info available)

## Recognition

Contributors will be:

- Listed in project credits (if you wish)
- Acknowledged in release notes
- Appreciated by the community

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

**Thank you for contributing to Lab4PurpleSec!** 🎉

Your efforts help make this project better for the entire cybersecurity community.
