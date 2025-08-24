# Architecture Overview

Iskandaria is designed as a modern digital library platform using Protocol Buffer-first API design.

## Current System Overview

```
┌─────────────────┐    
│   API Clients   │    
└─────────────────┘    
         │              
         │              
         ▼              
┌─────────────────┐     
│ HTTP API Server │ (planned)
└─────────────────┘     
         │              
         ▼              
┌─────────────────┐     
│  Song Service   │     
└─────────────────┘     
```

## Core Principles

### 1. Protocol Buffer First
- All APIs are defined using Protocol Buffers
- Type-safe communication
- Automatic code generation
- Built-in validation and documentation

### 2. Strongly Typed Identifiers
- UUID-based identifiers for all entities
- Type safety prevents ID mix-ups
- Clear entity relationships

## Project Structure

```
iskandaria/
├── cmd/                    # Application entry points
│   └── server/            # Main server application (minimal implementation)
│       └── main.go        # Basic server stub
├── contracts/             # Protocol Buffer API definitions (source of truth)
│   ├── core/v1/          # Shared types and utilities
│   │   ├── i18n.proto    # Internationalization support
│   │   └── ids.proto     # Strongly-typed identifiers (SongID, AlbumID, ArtistID)
│   └── song/v1/          # Song domain definitions
│       ├── service.proto # SongService API (GetSongs operation)
│       └── song.proto    # Song model with localized titles
├── api/                  # Generated API code (DO NOT EDIT MANUALLY)
│   └── contracts/        # Generated Go code from protobuf
├── api-docs/             # Generated OpenAPI documentation
├── scripts/              # Build and development scripts
└── docs/                 # Project documentation
```

## Current Implementation Status

### Completed Components

#### 1. API Contracts (contracts/)
- **Core Types**: UUID-based identifiers and internationalization
- **Song Models**: Basic song structure with localized titles
- **Song Service**: Single GetSongs operation
- **Validation**: Built-in validation rules using buf.validate

#### 2. Generated Code (api/)
- **Protocol Buffer Compilation**: Go structs generated from .proto files
- **HTTP Handlers**: REST endpoints generated via sebuf
- **OpenAPI Docs**: Automatic documentation generation

#### 3. Build System
- **Makefile**: Comprehensive build automation
- **Scripts**: Test execution with coverage analysis
- **CI/CD**: GitHub Actions for automated testing and linting

### Minimal Components

#### Server Application (cmd/server/)
Currently contains only a basic stub that exits immediately:
```go
func main() {
    os.Exit(0)
}
```

## Current API Design

### Song Service
The Song Service currently provides basic song retrieval:

**Available Operations:**
- `GetSongs` - Retrieve multiple songs by ID list

**Song Model Structure:**
```protobuf
message Song {
  core.v1.SongID id = 1;                    // UUID identifier
  core.v1.TranslatedString title = 2;       // Multi-language titles
  core.v1.ArtistID artist_id = 3;          // Artist reference
  core.v1.AlbumID album_id = 4;            // Album reference (optional)
  int32 duration_seconds = 5;              // Duration validation (> 0)
  int32 release_year = 6;                  // Release year (>= 1900)
}
```

### Core Types
Shared types across all services:

- **Identifiers**: SongID, AlbumID, ArtistID (UUID-based with validation)
- **Internationalization**: Multi-language text support for 4 languages
- **Validation**: Built-in field validation using buf.validate

## Technology Stack

### Core Technologies
- **Go 1.24.4**: Primary development language
- **Protocol Buffers**: API definition and serialization
- **Buf**: Protocol buffer toolkit for linting and generation
- **sebuf**: Custom HTTP/gRPC code generation framework

### Development Tools
- **golangci-lint**: Comprehensive code linting with 446-line configuration
- **go-test-coverage**: Coverage analysis targeting 85% coverage
- **GitHub Actions**: Multi-OS CI/CD pipeline (Ubuntu, macOS)
- **Make**: Build automation with 15+ commands

### Generated Code
Current code generation pipeline:

1. **Protocol Buffer Compilation**: `.proto` → `.pb.go` structs
2. **HTTP Handler Generation**: Service definitions → REST endpoints via sebuf
3. **OpenAPI Documentation**: Automatic YAML/JSON API specs
4. **Helper Methods**: Oneof helpers and validation code

## Generated API Endpoints

Based on the current Protocol Buffer definitions:

```
GET /api/v1/songs  # GetSongs operation
```

**Request Format:**
```json
{
  "song_id_list": [
    {"value": "uuid1"},
    {"value": "uuid2"}
  ]
}
```

## Development Workflow

### Current Build Process
1. **Install Tools**: `make install` - Installs buf, golangci-lint, coverage tools
2. **Generate Code**: `make generate` - Compiles protobuf and generates HTTP handlers  
3. **Build Binaries**: `make build` - Creates `bin/server` executable
4. **Run Tests**: `make test` or `make coverage` for full analysis
5. **Quality Check**: `make lint` for code quality validation

### Validation and Quality
- **85% Coverage Target**: Enforced via .testcoverage.yml
- **Comprehensive Linting**: 446-line golangci-lint configuration
- **Breaking Change Detection**: `buf breaking` validates API compatibility
- **Multi-OS Testing**: CI runs on Ubuntu and macOS

## Next Development Steps

The current implementation provides the foundation for:
1. Server implementation to handle the generated HTTP endpoints
2. Data persistence layer for song storage
3. Additional CRUD operations beyond GetSongs
4. Authentication and authorization

For detailed implementation guidance, see:
- [Development Setup](development-setup.md) - Environment configuration
- [Testing Guide](testing.md) - Testing best practices  
- [API Reference](api/) - Current API documentation