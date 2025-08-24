# Getting Started with Iskandaria

This guide will help you get Iskandaria up and running quickly on your local machine.

## Prerequisites

- **Go 1.24.4+** - [Download and install Go](https://golang.org/doc/install)
- **Git** - For cloning the repository
- **Make** - For running build commands (usually pre-installed on Unix systems)

## Quick Setup

### 1. Clone the Repository

```bash
git clone https://github.com/SebastienMelki/iskandaria.git
cd iskandaria
```

### 2. Install Dependencies and Tools

```bash
make install
```

This command installs:
- Go module dependencies
- Buf (Protocol Buffer toolkit)
- golangci-lint (Code linting)
- go-test-coverage (Coverage analysis)
- protoc-gen-go (Protocol Buffer Go generation)
- sebuf plugins (HTTP code generation)

### 3. Generate API Code

```bash
make generate
```

This generates Go code from Protocol Buffer definitions in the `contracts/` directory.

### 4. Build the Project

```bash
make build
```

This creates executable binaries in the `bin/` directory.

### 5. Run Tests

```bash
make test
```

Or run with coverage analysis:

```bash
make coverage
```

### 6. Start the Server

```bash
./bin/server
```

The server will start and listen for requests. Default configuration can be found in the server code.

## Verify Your Setup

Run the following commands to verify everything is working:

```bash
# Check that all tools are installed
make help

# Run linting
make lint

# Run full test suite with coverage
make coverage

# Clean and rebuild everything
make clean && make generate && make build
```

## Next Steps

- **[Development Setup](development-setup.md)** - Set up your development environment
- **[Architecture Overview](architecture.md)** - Understand the system design
- **[Contributing Guide](../CONTRIBUTING.md)** - Learn how to contribute
- **[API Documentation](api/)** - Explore the API reference

## Common Issues

### Go Version Compatibility
Ensure you're using Go 1.24.4 or higher:
```bash
go version
```

### Missing Dependencies
If you encounter missing tool errors, run:
```bash
make install
```

### Generated Code Issues
If you see import errors or missing files, regenerate the code:
```bash
make clean
make generate
```

### Test Failures
If tests fail, check the detailed output:
```bash
./scripts/run_tests.sh --verbose
```

## Project Structure

```
iskandaria/
├── cmd/server/          # Main application entry point
├── contracts/           # Protocol Buffer API definitions
├── api/                # Generated API code (do not edit)
├── internal/           # Private application code
├── pkg/                # Public libraries
├── scripts/            # Build and utility scripts
├── docs/               # Documentation
└── bin/                # Compiled binaries
```

For more detailed information, see the [Architecture Overview](architecture.md).