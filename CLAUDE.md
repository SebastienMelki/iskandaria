# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Iskandaria is a modern digital library platform inspired by the Library of Alexandria. It's a unified media repository for music, movies, series, audiobooks & podcasts - a self-hosted streaming platform with seamless playback, organization & discovery.

## Development Commands

### Essential Commands (Use Makefile)
```bash
# Install all development tools and dependencies
make install

# Run tests
make test

# Run tests with coverage analysis
make coverage

# Run linting
make lint

# Build the project
make build

# Generate protocol buffer code
make generate

# Clean build artifacts
make clean

# Show all available commands
make help
```

### Direct Go Commands
```bash
# Initialize/update dependencies
go mod tidy

# Run tests with race detection
go test -race ./...

# Run tests with verbose output
go test -v ./...

# Run a specific test
go test -run TestName ./path/to/package

# Format code
go fmt ./...

# Run the server
./bin/server
```

### Testing Commands
```bash
# Run tests with coverage (full analysis)
./scripts/run_tests.sh

# Run tests with verbose output
./scripts/run_tests.sh --verbose

# Run tests without coverage (faster)
./scripts/run_tests.sh --fast

# View coverage report in browser
open coverage/coverage.html
```

### Code Quality Commands
```bash
# Run all linters
golangci-lint run

# Run linters with auto-fix
golangci-lint run --fix

# Check code formatting
gofmt -l .

# Run go vet
go vet ./...
```

### Protocol Buffer Commands
```bash
# Lint proto files
buf lint contracts/

# Check for breaking changes
buf breaking contracts/ --against '.git#branch=main'

# Format proto files
buf format -w contracts/
```

## Project Structure

```
iskandaria/
├── api/              # Generated API contracts (DO NOT EDIT)
├── cmd/              # Application entry points
│   └── server/       # Main server application
├── contracts/        # Protocol buffer definitions (source of truth)
│   ├── core/         # Core shared types (i18n, ids)
│   └── song/         # Song service definitions
├── internal/         # Private application code
├── pkg/              # Public libraries
├── scripts/          # Build and test scripts
├── api-docs/         # Generated OpenAPI documentation
├── coverage/         # Test coverage reports (generated)
└── bin/              # Compiled binaries (generated)
```

## Development Guidelines

### Testing
- **Target Coverage**: 85% overall
- **Run tests before committing**: `make test`
- **Check coverage**: `make coverage`
- Generated files (*.pb.go) are excluded from coverage

### Code Quality
- **Always run linting**: `make lint` before committing
- **Format code**: `go fmt ./...` is enforced
- **Follow Go idioms** and conventions
- **Handle errors** explicitly

### Protocol Buffers
- Define APIs in `contracts/` directory
- Run `make generate` after modifying proto files
- Never manually edit files in `api/` directory
- Follow Buf style guide for proto files

### Git Workflow
1. Create feature branch from `main`
2. Make changes and test thoroughly
3. Run `make lint` and `make test`
4. Commit with conventional commit messages
5. Push and create Pull Request

## CI/CD Pipeline

GitHub Actions runs automatically on:
- Push to `main` or `develop` branches
- Pull requests to `main`

Pipeline includes:
1. **Linting** - Code quality checks
2. **Testing** - Multi-OS testing (Ubuntu, macOS)
3. **Coverage** - Coverage analysis and reporting
4. **Build** - Binary compilation
5. **Proto Validation** - Protocol buffer checks

## Important Notes

- **Go Version**: 1.24.4
- **Module Path**: github.com/SebastienMelki/iskandaria
- **License**: MIT
- **Main Dependencies**:
  - buf.build for protocol buffers
  - sebuf for HTTP/gRPC code generation
  - golangci-lint for code quality

## Common Tasks

### Adding a New Service
1. Create proto definitions in `contracts/[service]/v1/`
2. Run `make generate` to generate code
3. Implement service in `internal/service/[service]/`
4. Add tests with minimum 85% coverage
5. Update API documentation

### Fixing Linting Issues
1. Run `make lint` to see issues
2. Most issues can be auto-fixed: `golangci-lint run --fix`
3. Manual fixes may be needed for complex issues
4. Check `.golangci.yml` for linter configuration

### Debugging Test Failures
1. Run specific test: `go test -v -run TestName ./path`
2. Check race conditions: `go test -race ./...`
3. View coverage gaps: `make coverage && open coverage/coverage.html`
4. Use verbose mode: `./scripts/run_tests.sh --verbose`