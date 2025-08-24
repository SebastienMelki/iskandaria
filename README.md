# Iskandaria

[![Go Version](https://img.shields.io/badge/Go-1.24-blue)](https://golang.org/)
[![Build Status](https://img.shields.io/github/actions/workflow/status/SebastienMelki/iskandaria/ci.yml?branch=main)](https://github.com/SebastienMelki/iskandaria/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A modern Library of Alexandria for digital art

Iskandaria aims to be a unified media repository and streaming platform for preserving and enjoying digital content - music, movies, series, audiobooks, and podcasts.

## 🚀 Getting Started

### Prerequisites
- Go 1.24 or higher
- Protocol Buffers (for development)

### Installation

```bash
# Clone the repository
git clone https://github.com/SebastienMelki/iskandaria.git
cd iskandaria

# Install dependencies and tools
make install

# Generate API contracts from protobuf definitions
make generate

# Build the project
make build

# Run the server
./bin/server
```

## 🛠️ Development

### Commands

```bash
# Run tests
make test

# Run tests with coverage
make coverage

# Run linting
make lint

# Generate protobuf code
make generate

# See all available commands
make help
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
Built with ❤️ for preserving and enjoying digital art
</div>