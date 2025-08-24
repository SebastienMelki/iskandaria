# API Design Guide

Iskandaria uses Protocol Buffers as the foundation for all API design, ensuring type safety, validation, and automatic code generation.

## Design Principles

### 1. Protocol Buffer First
- All APIs are defined using Protocol Buffers (.proto files)
- Generated code provides type safety and consistency
- Automatic documentation generation (OpenAPI)
- Built-in validation via buf.validate

### 2. HTTP Mapping via sebuf
- HTTP endpoints are generated from service definitions
- Uses sebuf framework for HTTP code generation
- Configurable HTTP paths and methods
- Automatic JSON serialization

### 3. Strong Typing
- UUID-based identifiers with validation
- Typed identifiers prevent ID confusion
- Multi-language text support for internationalization

## Current API Structure

```
contracts/
├── core/v1/          # Shared types and utilities
│   ├── i18n.proto   # Multi-language support (4 languages)
│   └── ids.proto    # UUID-based identifiers (SongID, AlbumID, ArtistID)
└── song/v1/         # Song service domain  
    ├── service.proto # SongService with GetSongs operation
    └── song.proto   # Song model with localized titles
```

## Current Core Types

### Identifier Types (core/v1/ids.proto)
Strongly-typed UUID identifiers with validation:

```protobuf
message SongID {
  string value = 1;  // Must be valid UUID
}

message AlbumID {
  string value = 1; // Must be valid UUID  
}

message ArtistID {
  string value = 1; // Must be valid UUID
}
```

**Features:**
- UUID format validation via buf.validate
- Prevents mixing different ID types
- Includes example values for documentation

### Internationalization (core/v1/i18n.proto)
Multi-language text support:

```protobuf
enum Language {
  LANGUAGE_UNSPECIFIED = 0;
  LANGUAGE_ARABIC = 1;
  LANGUAGE_ENGLISH = 2; 
  LANGUAGE_FRENCH = 3;
  LANGUAGE_SPANISH = 4;
}

message Translation {
  Language language = 1; // Cannot be LANGUAGE_UNSPECIFIED
  string text = 2;       // 1-1000 characters
}

message TranslatedString {
  repeated Translation translations = 1; // 1-10 translations
}
```

**Features:**
- Support for 4 languages: Arabic, English, French, Spanish
- Validation: 1-10 translations per string, 1-1000 chars per text
- Rich examples for each language

## Current Service Definition

### SongService (song/v1/service.proto)
Currently implements a single operation:

```protobuf
service SongService {
  option (sebuf.http.service_config) = { 
    base_path: "/api/v1" 
  };
  
  // GetSongs retrieves multiple songs by ID list
  rpc GetSongs(GetSongsRequest) returns (GetSongsResponse) {
    option (sebuf.http.config) = { 
      path: "/songs" 
    };
  }
}
```

**Features:**
- HTTP mapping via sebuf annotations
- Base path configuration: `/api/v1`
- Single endpoint: `GET /api/v1/songs`

### Current Request/Response

#### GetSongsRequest
```protobuf
message GetSongsRequest {
  repeated core.v1.SongID song_id_list = 1; // 1-50 song IDs
}
```

**Validation:**
- Minimum 1 song ID required
- Maximum 50 song IDs allowed
- Each ID must be valid UUID

#### GetSongsResponse
```protobuf
message GetSongsResponse {
  repeated Song songs = 1;
}
```

## Current Song Model

### Song (song/v1/song.proto)
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

**Features:**
- UUID-based identifiers for all references
- Multi-language title support via TranslatedString
- Validation: duration > 0, release_year >= 1900
- Optional album association
- Rich example values for all fields

## HTTP Mapping

### Generated HTTP Endpoints
From the Protocol Buffer service definitions, the following HTTP endpoints are automatically generated:

```
POST   /api/v1/songs           # CreateSong
GET    /api/v1/songs/{id}      # GetSong  
PUT    /api/v1/songs/{id}      # UpdateSong
DELETE /api/v1/songs/{id}      # DeleteSong
GET    /api/v1/songs           # ListSongs
GET    /api/v1/songs:search    # SearchSongs
```

### Request/Response Examples

#### Create Song
```http
POST /api/v1/songs
Content-Type: application/json

{
  "title": "Bohemian Rhapsody",
  "artist": "Queen",
  "album": "A Night at the Opera",
  "duration_seconds": 354,
  "file_url": "https://example.com/songs/bohemian-rhapsody.mp3"
}
```

Response:
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "song": {
    "id": {"value": "song-123"},
    "title": "Bohemian Rhapsody",
    "artist": "Queen",
    "album": "A Night at the Opera",
    "duration_seconds": 354,
    "file_url": "https://example.com/songs/bohemian-rhapsody.mp3",
    "created_at": "2024-01-15T10:00:00Z",
    "updated_at": "2024-01-15T10:00:00Z"
  }
}
```

#### List Songs with Filtering
```http
GET /api/v1/songs?filter.artist=Queen&page_size=10&page_token=abc123
```

Response:
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "songs": [
    {
      "id": {"value": "song-123"},
      "title": "Bohemian Rhapsody",
      "artist": "Queen",
      ...
    }
  ],
  "next_page_token": "def456",
  "total_count": 25
}
```

## Validation Rules

### Built-in Validation
Protocol Buffers provide built-in validation through the `buf.validate` extension:

```protobuf
import "buf/validate/validate.proto";

message CreateSongRequest {
  string title = 1 [(buf.validate.field).string.min_len = 1];
  string artist = 2 [(buf.validate.field).string.min_len = 1];
  string album = 3;
  int32 duration_seconds = 4 [(buf.validate.field).int32.gt = 0];
  string file_url = 5 [(buf.validate.field).string.uri = true];
}
```

### Custom Validation
Additional validation logic in service implementations:

```go
func (s *SongService) CreateSong(ctx context.Context, req *pb.CreateSongRequest) (*pb.CreateSongResponse, error) {
    // Protocol buffer validation is automatic
    
    // Custom business logic validation
    if req.DurationSeconds > 3600 { // 1 hour max
        return nil, status.Error(codes.InvalidArgument, "song duration too long")
    }
    
    // Continue with creation logic...
}
```

## Error Handling

### Standard Error Response
```protobuf
message ErrorResponse {
  int32 code = 1;
  string message = 2;
  repeated ErrorDetail details = 3;
}

message ErrorDetail {
  string field = 1;
  string error = 2;
}
```

### HTTP Status Code Mapping
- `200 OK` - Successful GET, PUT operations
- `201 Created` - Successful POST operations
- `204 No Content` - Successful DELETE operations
- `400 Bad Request` - Validation errors
- `404 Not Found` - Resource not found
- `409 Conflict` - Resource conflicts
- `500 Internal Server Error` - Server errors

## OpenAPI Documentation

### Automatic Generation
OpenAPI specifications are automatically generated from Protocol Buffer definitions:

```bash
# Generate OpenAPI docs
make generate

# View generated documentation
ls api-docs/
# SongService.openapi.yaml
# SongService.openapi.json
```

### Documentation Annotations
```protobuf
service SongService {
  // Creates a new song in the library
  // 
  // This endpoint allows you to add a new song to the music library.
  // The song file must be uploaded separately and the file_url provided.
  rpc CreateSong(CreateSongRequest) returns (CreateSongResponse) {
    option (google.api.http) = {
      post: "/api/v1/songs"
      body: "*"
    };
  }
}
```

## Best Practices

### 1. Message Design
- Use clear, descriptive field names
- Group related fields together  
- Use optional for truly optional fields
- Provide reasonable defaults

### 2. Service Design
- Keep services focused on a single domain
- Use consistent naming patterns
- Include proper pagination for list operations
- Design for idempotency where appropriate

### 3. Versioning
- Version packages (v1, v2, etc.)
- Use semantic versioning
- Maintain backward compatibility within major versions
- Provide migration guides for breaking changes

### 4. Documentation
- Add comments to all services and messages
- Include usage examples
- Document validation rules
- Explain complex business logic

## Development Workflow

### 1. Design API Contract
```bash
# Edit proto files in contracts/
vim contracts/song/v1/service.proto
```

### 2. Validate Design
```bash
# Lint proto files
buf lint contracts/

# Check for breaking changes
buf breaking contracts/ --against '.git#branch=main'
```

### 3. Generate Code
```bash
# Generate Go code and OpenAPI docs
make generate
```

### 4. Implement Service
```go
// Implement the generated service interface
type songService struct {
    repo SongRepository
}

func (s *songService) CreateSong(ctx context.Context, req *pb.CreateSongRequest) (*pb.CreateSongResponse, error) {
    // Implementation
}
```

### 5. Test API
```bash
# Run tests
make test

# Test with coverage
make coverage
```

## Tools and Configuration

### Buf Configuration (buf.yaml)
```yaml
version: v1
name: buf.build/sebastienmelki/iskandaria
breaking:
  use:
    - FILE
lint:
  use:
    - DEFAULT
```

### Code Generation (buf.gen.yaml)
```yaml
version: v1
plugins:
  - plugin: go
    out: api
    opt: paths=source_relative
  - plugin: go-oneof-helper
    out: api  
    opt: paths=source_relative
  - plugin: go-http
    out: api
    opt: paths=source_relative
  - plugin: openapiv3
    out: api-docs
```

## Next Steps

- **[Architecture Overview](architecture.md)** - Understand the system design
- **[Development Setup](development-setup.md)** - Set up your environment
- **[Testing Guide](testing.md)** - Test your API implementations
- **[API Reference](api/)** - Detailed API documentation