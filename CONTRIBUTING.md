# Contributing to The-Void

Thank you for venturing into The-Void, a PowerShell-based tool for seamless data transfers from removable drives to network shares! We welcome contributions to enhance Dumps.exe, especially through testing, bug reporting, and feature suggestions. This guide outlines how to contribute to this shadowed utility.

## How to Contribute

### 1. Reporting Bugs

We need testers to unearth flaws in Dumps.exe and its source, Dumps.ps1. To report a bug:

- **Check Existing Issues**: Search the [Issues](https://github.com/LordSodomiser/The-Void/issues) page to avoid duplicates.
- **Create a New Issue**: Use the bug report template provided in the repository. Include:
  - A clear description of the bug.
  - Steps to reproduce it.
  - Expected vs. actual behavior.
  - Your environment (e.g., Windows version, PowerShell version).
  - Logs from Phone Dump Logs or screenshots, if applicable.
- **Be Specific**: Detailed reports help us address issues faster.

### 2. Suggesting Features

Got ideas to deepen The-Void’s capabilities? We’re open to enhancements like advanced GUI options or custom Robocopy parameters. To suggest a feature:

- Open a [new issue](https://github.com/LordSodomiser/The-Void/issues) using the feature request template.
- Describe the feature, its use case, and how it aids data transfer workflows.
- Ensure it aligns with the project’s goal of reliability and minimal user intervention.

### 3. Submitting Code

Want to forge fixes or new features? Dive in! Here’s how:

- **Fork the Repository**: Create your own fork of [The-Abyss](https://github.com/LordSodomiser/The-Void).
- **Clone and Branch**:
  ```bash
  git clone https://github.com/<your-username>/The-Abyss.git
  cd The-Abyss
  git checkout -b feature/your-feature-name
  ```
- **Make Changes**: Keep code lightweight, PowerShell-based, and compatible with Windows environments. Follow the structure of Dumps.ps1.
- **Test Thoroughly**: Ensure changes work on Windows 10/11 with PowerShell 5.1 or later.
- **Commit and Push**:
  ```bash
  git commit -m "Add feature/fix: brief description"
  git push origin feature/your-feature-name
  ```
- **Open a Pull Request**: Submit a PR with a clear title and description. Reference any related issues.

### 4. Testing the Dumps

Testers are vital to ensure Dumps.exe is robust! To help:

- Download the latest release (v0.1.0) and follow the [README](README.md) Quick Start guide.
- Test on your Windows system, focusing on USB-to-network transfers and screen lock scenarios.
- Verify integrity using the SHA512 checksums for Dumps.exe and Dumps.ps1.
- Share feedback on usability, performance, or potential improvements.

## Code of Conduct

- Be respectful and inclusive in all interactions.
- Provide constructive feedback and avoid personal attacks.
- Uphold the project’s aim of reliable, automated data transfers.

## Development Guidelines

- **Code Style**: Follow PowerShell best practices (e.g., use Set-StrictMode, include error handling).
- **Documentation**: Update relevant documentation (e.g., README, inline comments) with your changes.
- **Testing**: Ensure compatibility with Windows 10/11 and PowerShell 5.1 or later.
- **Licensing**: Contributions are licensed under the MIT License, matching the project.

## Questions?

Have questions or need help? Open an issue or join our community discussion (details in the README). Your contributions, big or small, help The-Void consume the chaos of data transfers!
