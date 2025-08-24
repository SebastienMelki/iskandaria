# Testing Guide

Iskandaria follows comprehensive testing practices to ensure code quality and reliability. This guide covers testing strategies, tools, and best practices.

## Testing Philosophy

- **Test-Driven Development (TDD)**: Write tests before implementation when possible
- **High Coverage**: Target 85% code coverage across the project
- **Fast Feedback**: Quick test execution for rapid development cycles
- **Comprehensive Testing**: Unit, integration, and end-to-end tests

## Testing Tools and Configuration

### Core Testing Tools
- **Go testing package**: Built-in testing framework
- **testify**: Assertion library for readable tests
- **go-test-coverage**: Coverage analysis and reporting
- **race detector**: Concurrent code testing

### Test Configuration Files

#### .testcoverage.yml
```yaml
# Coverage threshold (85%)
# Excludes generated files (*.pb.go)
# Configures package-level coverage rules
```

#### Test Script (scripts/run_tests.sh)
```bash
# Automated test execution with coverage
# Multiple execution modes (fast, verbose, coverage)
# HTML and JSON coverage report generation
```

## Test Types and Structure

### 1. Unit Tests

Test individual functions and methods in isolation.

```go
// Example: Song service unit test
func TestSongService_Create(t *testing.T) {
    // Arrange
    service := NewSongService()
    request := &contracts.CreateSongRequest{
        Title:  "Test Song",
        Artist: "Test Artist",
        Album:  "Test Album",
    }
    
    // Act
    response, err := service.Create(context.Background(), request)
    
    // Assert
    assert.NoError(t, err)
    assert.NotNil(t, response)
    assert.Equal(t, "Test Song", response.Title)
    assert.Equal(t, "Test Artist", response.Artist)
}
```

### 2. Integration Tests

Test interactions between components and external dependencies.

```go
func TestSongRepository_Integration(t *testing.T) {
    // Setup test database
    db := setupTestDB(t)
    defer cleanupTestDB(t, db)
    
    repo := NewSongRepository(db)
    
    // Test repository operations
    song := &domain.Song{
        Title:  "Integration Test",
        Artist: "Test Artist",
    }
    
    savedSong, err := repo.Save(context.Background(), song)
    assert.NoError(t, err)
    assert.NotEmpty(t, savedSong.ID)
    
    retrievedSong, err := repo.GetByID(context.Background(), savedSong.ID)
    assert.NoError(t, err)
    assert.Equal(t, song.Title, retrievedSong.Title)
}
```

### 3. HTTP Handler Tests

Test API endpoints with HTTP requests and responses.

```go
func TestSongHandler_Create(t *testing.T) {
    // Setup test server
    handler := setupTestHandler(t)
    server := httptest.NewServer(handler)
    defer server.Close()
    
    // Prepare request
    requestBody := `{
        "title": "Test Song",
        "artist": "Test Artist"
    }`
    
    // Make request
    resp, err := http.Post(
        server.URL+"/api/v1/songs",
        "application/json",
        strings.NewReader(requestBody),
    )
    
    // Assert response
    assert.NoError(t, err)
    assert.Equal(t, http.StatusCreated, resp.StatusCode)
    
    var response contracts.Song
    err = json.NewDecoder(resp.Body).Decode(&response)
    assert.NoError(t, err)
    assert.Equal(t, "Test Song", response.Title)
}
```

## Testing Commands

### Development Testing
```bash
# Fast tests during development (no coverage)
make test

# Equivalent to:
./scripts/run_tests.sh --fast
```

### Comprehensive Testing
```bash
# Full test suite with coverage analysis
make coverage

# Equivalent to:
./scripts/run_tests.sh
```

### Verbose Testing
```bash
# Detailed test output for debugging
./scripts/run_tests.sh --verbose
```

### Specific Package Testing
```bash
# Test specific package
go test -v ./internal/service/song

# Run specific test
go test -run TestSongService_Create ./internal/service/song

# Run tests with race detection
go test -race ./...
```

## Coverage Analysis

### Coverage Targets
- **Overall Project**: 85% minimum coverage
- **New Code**: 90%+ coverage for new features
- **Critical Paths**: 95%+ coverage for core business logic

### Coverage Reports
```bash
# Generate coverage reports
make coverage

# View HTML coverage report
open coverage/coverage.html

# View coverage summary
cat coverage/coverage.json
```

### Coverage Exclusions
Generated files are excluded from coverage analysis:
- `*.pb.go` - Protocol buffer generated code
- `*_mock.go` - Mock implementations
- Generated HTTP handlers (when applicable)

## Test Organization

### File Naming Conventions
- `*_test.go` - Unit tests in the same package
- `*_integration_test.go` - Integration tests
- `test_helpers.go` - Shared test utilities

### Package Structure
```
internal/service/song/
├── song.go              # Implementation
├── song_test.go         # Unit tests
├── song_integration_test.go  # Integration tests
└── test_helpers.go      # Test utilities
```

### Test Data Management
```go
// Test data builders for consistent test setup
func NewTestSong() *domain.Song {
    return &domain.Song{
        ID:     "test-song-id",
        Title:  "Test Song",
        Artist: "Test Artist",
        Album:  "Test Album",
    }
}

func NewTestCreateSongRequest() *contracts.CreateSongRequest {
    return &contracts.CreateSongRequest{
        Title:  "Test Song",
        Artist: "Test Artist",
        Album:  "Test Album",
    }
}
```

## Testing Best Practices

### 1. Test Structure (AAA Pattern)
```go
func TestFunction(t *testing.T) {
    // Arrange - Set up test data and dependencies
    input := "test input"
    expectedOutput := "expected result"
    
    // Act - Execute the function under test
    actualOutput := functionUnderTest(input)
    
    // Assert - Verify the results
    assert.Equal(t, expectedOutput, actualOutput)
}
```

### 2. Table-Driven Tests
```go
func TestValidation(t *testing.T) {
    tests := []struct {
        name          string
        input         string
        expectedError bool
    }{
        {"valid input", "valid@example.com", false},
        {"invalid input", "invalid-email", true},
        {"empty input", "", true},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            err := validateEmail(tt.input)
            if tt.expectedError {
                assert.Error(t, err)
            } else {
                assert.NoError(t, err)
            }
        })
    }
}
```

### 3. Mock Dependencies
```go
type mockRepository struct {
    songs map[string]*domain.Song
}

func (m *mockRepository) Save(ctx context.Context, song *domain.Song) error {
    m.songs[song.ID] = song
    return nil
}

func TestServiceWithMock(t *testing.T) {
    mockRepo := &mockRepository{songs: make(map[string]*domain.Song)}
    service := NewSongService(mockRepo)
    
    // Test service using mock repository
}
```

### 4. Test Cleanup
```go
func TestWithCleanup(t *testing.T) {
    // Setup
    resource := setupExpensiveResource()
    
    // Cleanup after test
    t.Cleanup(func() {
        resource.Close()
    })
    
    // Test logic
}
```

## Integration Test Setup

### Database Testing
```go
func setupTestDB(t *testing.T) *sql.DB {
    // Use in-memory database for tests
    db, err := sql.Open("sqlite3", ":memory:")
    require.NoError(t, err)
    
    // Run migrations
    runMigrations(db)
    
    return db
}

func cleanupTestDB(t *testing.T, db *sql.DB) {
    err := db.Close()
    require.NoError(t, err)
}
```

### HTTP Server Testing
```go
func setupTestHandler(t *testing.T) http.Handler {
    // Create test dependencies
    mockService := &mockSongService{}
    
    // Setup handler with test dependencies
    return NewSongHandler(mockService)
}
```

## Performance Testing

### Benchmark Tests
```go
func BenchmarkSongService_Create(b *testing.B) {
    service := setupBenchmarkService()
    request := NewTestCreateSongRequest()
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _, err := service.Create(context.Background(), request)
        if err != nil {
            b.Fatal(err)
        }
    }
}
```

### Memory Allocation Testing
```go
func TestMemoryUsage(t *testing.T) {
    var m1, m2 runtime.MemStats
    runtime.GC()
    runtime.ReadMemStats(&m1)
    
    // Run function that might allocate memory
    result := expensiveFunction()
    
    runtime.GC()
    runtime.ReadMemStats(&m2)
    
    // Assert reasonable memory usage
    memUsed := m2.Alloc - m1.Alloc
    assert.Less(t, memUsed, uint64(1024*1024)) // Less than 1MB
}
```

## CI/CD Testing

### GitHub Actions Integration
The project includes comprehensive CI/CD testing:
- Multi-OS testing (Ubuntu, macOS)
- Go version matrix testing
- Race condition detection
- Coverage reporting
- Lint checking

### Pre-commit Hooks
Consider setting up pre-commit hooks:
```bash
#!/bin/bash
set -e
echo "Running pre-commit tests..."
make lint
make test
echo "Pre-commit tests passed!"
```

## Troubleshooting Tests

### Common Issues

1. **Race Conditions**
   ```bash
   # Run with race detector
   go test -race ./...
   ```

2. **Flaky Tests**
   ```bash
   # Run tests multiple times
   go test -count=10 ./path/to/flaky/test
   ```

3. **Coverage Issues**
   ```bash
   # Check which lines are not covered
   open coverage/coverage.html
   ```

4. **Slow Tests**
   ```bash
   # Profile test execution
   go test -cpuprofile=cpu.prof -memprofile=mem.prof ./...
   ```

### Debug Test Failures
```bash
# Run specific test with verbose output
go test -v -run TestSpecificFunction ./package

# Run with debug information
go test -v -args -test.debug ./package
```

## Next Steps

- **[Code Style Guide](code-style.md)** - Follow coding conventions
- **[Contributing Guide](../CONTRIBUTING.md)** - Submit tested contributions
- **[Development Setup](development-setup.md)** - Set up your test environment