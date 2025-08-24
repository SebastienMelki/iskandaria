# Iskandaria - Your Personal Digital Library

[![Go Version](https://img.shields.io/badge/Go-1.24-blue)](https://golang.org/)
[![Build Status](https://img.shields.io/github/actions/workflow/status/SebastienMelki/iskandaria/ci.yml?branch=main)](https://github.com/SebastienMelki/iskandaria/actions)
[![Test Coverage](https://img.shields.io/badge/coverage-85%25-green)](./coverage/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A modern digital library inspired by the Library of Alexandria

Iskandaria is a unified media repository for music, movies, series, audiobooks & podcasts. It's a self-hosted streaming platform with seamless playback, organization & discovery. Your personal archive for all digital content in one centralized hub.

## 🎯 Features

### Media Support
- **Music** - Stream your personal music collection
- **Movies** - Organize and watch your movie library
- **Series** - Track and stream TV shows
- **Audiobooks** - Listen to your audiobook collection
- **Podcasts** - Subscribe and manage podcast feeds

### Core Capabilities
- **Unified Interface** - Single platform for all media types
- **Smart Organization** - Automatic metadata fetching and categorization
- **Discovery Engine** - Recommendations based on your library
- **Multi-User Support** - Create profiles for family members
- **Cross-Platform** - Access from any device
- **Offline Support** - Download for offline playback

## 🚀 Quick Start

### Prerequisites
- Go 1.24 or higher
- Protocol Buffers compiler (for development)
- PostgreSQL (for production deployment)

### Installation

```bash
# Clone the repository
git clone https://github.com/SebastienMelki/iskandaria.git
cd iskandaria

# Install dependencies
make install

# Generate API contracts
make generate

# Build the server
make build

# Run the server
./bin/server
```

### Docker Deployment

```bash
# Using Docker Compose (recommended)
docker-compose up -d

# Or using Docker directly
docker run -d \
  -p 8080:8080 \
  -v /path/to/media:/media \
  -v /path/to/config:/config \
  ghcr.io/sebastienmelki/iskandaria:latest
```

## 🏗️ Architecture

Iskandaria follows a microservices architecture with the following components:

```
┌─────────────────────────────────────────────────┐
│                   Web UI                        │
├─────────────────────────────────────────────────┤
│              API Gateway (gRPC/HTTP)            │
├─────────┬───────────┬───────────┬──────────────┤
│  Song   │   Movie   │  Series   │   Podcast    │
│ Service │  Service  │  Service  │   Service    │
├─────────┴───────────┴───────────┴──────────────┤
│           Shared Infrastructure                 │
│  (Auth, Storage, Search, Metadata, Database)   │
└─────────────────────────────────────────────────┘
```

### Technology Stack
- **Backend**: Go 1.24
- **API**: gRPC with HTTP/JSON gateway
- **Database**: PostgreSQL with migrations
- **Search**: Elasticsearch for media discovery
- **Storage**: S3-compatible object storage
- **Cache**: Redis for performance
- **Queue**: NATS for event streaming

## 📚 API Documentation

The API is defined using Protocol Buffers and automatically generates:
- OpenAPI/Swagger documentation
- gRPC service definitions
- HTTP REST endpoints

View the API documentation:
- [Song Service API](./api-docs/SongService.openapi.yaml)
- More services coming soon...

### Example API Usage

```bash
# Create a new song entry
curl -X POST http://localhost:8080/v1/songs \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Bohemian Rhapsody",
    "artist": "Queen",
    "album": "A Night at the Opera",
    "duration": 354
  }'

# Search for songs
curl http://localhost:8080/v1/songs?q=queen
```

## 🛠️ Development

### Project Structure
```
iskandaria/
├── api/              # Generated API contracts
├── cmd/              # Application entry points
│   └── server/       # Main server application
├── contracts/        # Protocol buffer definitions
│   ├── core/         # Core shared types
│   └── song/         # Song service definitions
├── internal/         # Private application code
├── pkg/              # Public libraries
├── scripts/          # Build and test scripts
└── api-docs/         # Generated API documentation
```

### Development Commands

```bash
# Run tests
make test

# Run tests with coverage
make coverage

# Run linting
make lint

# Generate protobuf code
make generate

# Clean build artifacts
make clean

# See all available commands
make help
```

### Testing

The project maintains high test coverage standards:
- Target: 85% overall coverage
- Run tests: `make test`
- Coverage report: `make coverage`
- View HTML report: `open coverage/coverage.html`

### Code Quality

We use `golangci-lint` for code quality:
```bash
# Run all linters
make lint

# Auto-fix issues (where possible)
golangci-lint run --fix
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### How to Contribute
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup
1. Install Go 1.24+
2. Install development tools: `make install`
3. Set up pre-commit hooks (optional)
4. Run tests before submitting PRs

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the ancient Library of Alexandria
- Built with [Protocol Buffers](https://protobuf.dev/) and [Buf](https://buf.build/)
- Powered by the Go community

## 📮 Contact & Support

- **Issues**: [GitHub Issues](https://github.com/SebastienMelki/iskandaria/issues)
- **Discussions**: [GitHub Discussions](https://github.com/SebastienMelki/iskandaria/discussions)
- **Security**: Please report security vulnerabilities privately

## 🗺️ Roadmap

### Phase 1: Foundation (Current)
- [x] Core API structure
- [x] Song service implementation
- [ ] User authentication
- [ ] Basic web UI

### Phase 2: Media Services
- [ ] Movie service
- [ ] Series service with episode tracking
- [ ] Audiobook service with bookmarks
- [ ] Podcast service with RSS support

### Phase 3: Advanced Features
- [ ] Recommendation engine
- [ ] Social features (sharing, reviews)
- [ ] Mobile applications
- [ ] Hardware transcoding support

### Phase 4: Ecosystem
- [ ] Plugin system
- [ ] Third-party integrations
- [ ] Federation support
- [ ] Advanced analytics

---

<div align="center">
Built with ❤️ for digital archivists and media enthusiasts
</div>