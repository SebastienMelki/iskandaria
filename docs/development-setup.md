# Development Setup

This guide covers setting up a complete development environment for Iskandaria.

## Development Tools Installation

### Core Requirements

1. **Go 1.24.4+**
   ```bash
   # Verify installation
   go version
   ```

2. **Git**
   ```bash
   git --version
   ```

3. **Make**
   ```bash
   make --version
   ```

### Automated Tool Installation

The project includes automated installation of all development tools:

```bash
make install
```

This installs:
- **buf** - Protocol Buffer toolkit for linting, breaking change detection, and code generation
- **golangci-lint** - Comprehensive Go linter
- **go-test-coverage** - Coverage analysis and badge generation  
- **protoc-gen-go** - Official Protocol Buffer Go plugin
- **sebuf plugins** - Custom HTTP/gRPC code generation tools

### Manual Tool Installation (if needed)

If the automated installation fails, install tools manually:

```bash
# Buf for protocol buffers
go install github.com/bufbuild/buf/cmd/buf@latest

# golangci-lint for code quality
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Coverage analysis
go install github.com/vladopajic/go-test-coverage/v2@latest

# Protocol buffer Go generation
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

# sebuf plugins for HTTP/gRPC generation
GOPROXY=direct go install github.com/SebastienMelki/sebuf/cmd/protoc-gen-go-oneof-helper@latest
GOPROXY=direct go install github.com/SebastienMelki/sebuf/cmd/protoc-gen-go-http@latest  
GOPROXY=direct go install github.com/SebastienMelki/sebuf/cmd/protoc-gen-openapiv3@latest
```

## IDE Setup

### Visual Studio Code

Recommended extensions:
- **Go** (official Go team extension)
- **Protocol Buffers** - Syntax highlighting for .proto files
- **golangci-lint** - Integration with linter
- **Test Explorer** - Better test runner interface

Workspace settings (`.vscode/settings.json`):
```json
{
  "go.useLanguageServer": true,
  "go.lintTool": "golangci-lint",
  "go.testFlags": ["-v"],
  "files.exclude": {
    "**/api/": true,
    "**/bin/": true,
    "**/coverage/": true
  }
}
```

### GoLand/IntelliJ

- Install Protocol Buffers plugin
- Configure Go modules support
- Set up integrated terminal for make commands
- Configure test runner to use `-v` flag

## Development Workflow

### 1. Project Structure

```
iskandaria/
├── cmd/                 # Application entry points
│   └── server/         # Main server application  
├── contracts/          # Protocol Buffer definitions (source of truth)
│   ├── core/v1/       # Shared types (i18n, ids)
│   └── song/v1/       # Song service definitions
├── api/               # Generated code (DO NOT EDIT)
├── internal/          # Private application code
├── pkg/               # Public libraries
├── scripts/           # Build and utility scripts
├── docs/              # Documentation
├── coverage/          # Test coverage reports (generated)
└── bin/               # Compiled binaries (generated)
```

### 2. Daily Development Commands

```bash
# Start fresh development session
make clean && make generate && make build

# Run tests during development
make test

# Run comprehensive tests with coverage
make coverage

# Check code quality
make lint

# Auto-fix linting issues
make lint-fix

# View all available commands
make help
```

### 3. Working with Protocol Buffers

When modifying API definitions:

```bash
# 1. Edit files in contracts/ directory
# 2. Regenerate code
make generate

# 3. Verify no breaking changes
buf breaking contracts/ --against '.git#branch=main'

# 4. Format proto files
buf format -w contracts/

# 5. Lint proto files
buf lint contracts/
```

### 4. Testing Workflow

```bash
# Fast tests during development
make test

# Full testing with coverage analysis
make coverage

# Run specific package tests
go test ./internal/service/song

# Run with verbose output
./scripts/run_tests.sh --verbose

# View coverage report
open coverage/coverage.html
```

## Configuration Files

### Makefile
Central build automation with common development tasks.

### .golangci.yml
Comprehensive linting configuration covering:
- Code quality checks
- Performance optimization
- Security vulnerability detection
- Code complexity analysis

### .testcoverage.yml
Test coverage configuration:
- 85% minimum coverage threshold
- Excludes generated files from coverage
- Configures coverage analysis rules

### buf.yaml & buf.gen.yaml
Protocol Buffer configuration:
- Code generation settings
- Plugin configurations
- Breaking change detection rules

## Environment Variables

For local development, you may need to set:

```bash
# Go module proxy for sebuf dependencies
export GOPROXY=direct

# Increase coverage threshold if needed
export COVERAGE_THRESHOLD=85

# Enable race detection in tests
export GORACE="halt_on_error=1"
```

## Git Hooks (Optional)

Set up pre-commit hooks to ensure code quality:

```bash
# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
set -e

echo "Running pre-commit checks..."

# Run linting
make lint

# Run tests
make test

echo "Pre-commit checks passed!"
EOF

chmod +x .git/hooks/pre-commit
```

## Troubleshooting

### Common Issues

1. **Tool Not Found Errors**
   ```bash
   # Ensure $GOPATH/bin is in your PATH
   export PATH=$PATH:$(go env GOPATH)/bin
   
   # Or reinstall tools
   make install
   ```

2. **Generated Code Issues**
   ```bash
   # Clean and regenerate
   make clean
   make generate
   ```

3. **Module Download Issues**
   ```bash
   # Clear module cache
   go clean -modcache
   go mod download
   ```

4. **Test Failures**
   ```bash
   # Run with verbose output to see details
   ./scripts/run_tests.sh --verbose
   ```

### Performance Tips

- Use `make test` (fast mode) during development
- Use `make coverage` before committing
- Run `make lint-fix` to auto-fix many linting issues
- Use `go test -run TestSpecific` for targeted testing

## Next Steps

- **[Testing Guide](testing.md)** - Learn testing best practices
- **[Code Style Guide](code-style.md)** - Follow project conventions
- **[Contributing Guide](../CONTRIBUTING.md)** - Submit your first contribution