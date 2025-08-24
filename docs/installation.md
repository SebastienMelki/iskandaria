# Installation Guide

Step-by-step installation instructions for Iskandaria.

## Prerequisites

### System Requirements
- **Operating System**: Linux, macOS, or Windows
- **Go**: Version 1.24.4 or higher
- **Git**: For repository management
- **Make**: For build automation (pre-installed on most Unix systems)

### Verify Prerequisites

```bash
# Check Go version
go version
# Should show: go version go1.24.4 or higher

# Check Git
git --version

# Check Make
make --version
```

## Installation Steps

### 1. Clone Repository

```bash
git clone https://github.com/SebastienMelki/iskandaria.git
cd iskandaria
```

### 2. Install Development Tools

This command installs all required development tools automatically:

```bash
make install
```

**Tools Installed:**
- `buf` - Protocol Buffer toolkit
- `golangci-lint` - Code linter
- `go-test-coverage` - Coverage analysis
- `protoc-gen-go` - Protocol Buffer Go generation
- `sebuf` plugins - HTTP/gRPC code generation

### 3. Generate API Code

```bash
make generate
```

This creates:
- Go code from Protocol Buffer definitions (`api/` directory)
- OpenAPI documentation (`api-docs/` directory)

### 4. Build Project

```bash
make build
```

This creates executable binaries in the `bin/` directory.

### 5. Verify Installation

Run the test suite to verify everything works:

```bash
make test
```

Run with coverage analysis:

```bash
make coverage
```

Check code quality:

```bash
make lint
```

## What Gets Installed

### Generated Directories
After successful installation, you'll have:

```
iskandaria/
├── bin/                 # Compiled binaries
│   └── server          # Main server executable (basic stub)
├── api/                # Generated Go code from Protocol Buffers
│   └── contracts/      # Generated structs and HTTP handlers
├── api-docs/           # Generated OpenAPI documentation
│   ├── SongService.openapi.yaml
│   └── SongService.openapi.json
└── coverage/           # Test coverage reports (after running tests)
    ├── coverage.html
    ├── coverage.json
    └── coverage.out
```

### Available Commands

After installation, these commands are available via the Makefile:

```bash
make help      # Show all available commands
make install   # Install development tools  
make generate  # Generate code from Protocol Buffers
make build     # Build executable binaries
make test      # Run tests (fast mode)
make coverage  # Run tests with coverage analysis
make lint      # Run code linting
make lint-fix  # Run linting with auto-fixes
make clean     # Clean generated files and binaries
```

## Current State

### What Works
- Protocol Buffer compilation
- HTTP endpoint generation
- OpenAPI documentation generation
- Code linting and testing infrastructure
- Build system automation

### What's Minimal
- **Server Implementation**: Currently just a stub that exits
- **No Runtime Services**: Generated handlers exist but aren't wired up
- **No Data Persistence**: No database or storage layer yet

## Troubleshooting

### Common Issues

#### Go Version Too Old
```bash
# Error: go version is too old
# Solution: Upgrade Go to 1.24.4 or higher
go version
```

#### Tool Installation Fails
```bash
# If `make install` fails, try manual installation:
go install github.com/bufbuild/buf/cmd/buf@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

#### Permission Issues
```bash
# On Unix systems, ensure Go bin directory is in PATH:
export PATH=$PATH:$(go env GOPATH)/bin
```

#### Generated Code Issues
```bash
# Clean and regenerate if code generation fails:
make clean
make generate
```

#### sebuf Plugin Issues
```bash
# If sebuf plugins fail to install, use direct proxy:
GOPROXY=direct go install github.com/SebastienMelki/sebuf/cmd/protoc-gen-go-oneof-helper@latest
GOPROXY=direct go install github.com/SebastienMelki/sebuf/cmd/protoc-gen-go-http@latest
GOPROXY=direct go install github.com/SebastienMelki/sebuf/cmd/protoc-gen-openapiv3@latest
```

## Next Steps

After successful installation:

1. **[Getting Started](getting-started.md)** - Quick introduction to the project
2. **[Development Setup](development-setup.md)** - Set up your development environment  
3. **[Architecture Overview](architecture.md)** - Understand the system design
4. **[API Reference](api/)** - Explore the current API definitions

## Verification Checklist

- [ ] Go 1.24.4+ installed and working
- [ ] Repository cloned successfully
- [ ] `make install` completed without errors
- [ ] `make generate` created `api/` and `api-docs/` directories
- [ ] `make build` created `bin/server` executable  
- [ ] `make test` runs successfully
- [ ] `make lint` passes without errors

You're ready to start developing with Iskandaria!