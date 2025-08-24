# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Go project named "iskandaria" that appears to be in its initial setup phase. The project uses Go 1.24.4 and follows standard Go module conventions.

## Development Commands

### Basic Go Commands
```bash
# Initialize/update dependencies
go mod tidy

# Build the project
go build ./...

# Run tests
go test ./...

# Run tests with verbose output
go test -v ./...

# Run a specific test
go test -run TestName ./path/to/package

# Format code
go fmt ./...

# Lint code (requires golangci-lint installation)
golangci-lint run

# Run the main application (once main.go exists)
go run main.go
```

## Project Structure

Currently minimal structure with:
- `go.mod`: Go module definition for github.com/SebastienMelki/iskandaria

This project appears to be a fresh Go module initialization. Future development will likely follow standard Go project conventions with packages organized under the root directory.

## Development Notes

- Uses Go 1.24.4
- Module path: github.com/SebastienMelki/iskandaria
- Project is using Git for version control
- IntelliJ IDEA configuration present (`.idea/` directory)