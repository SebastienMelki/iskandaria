# Contributing to Iskandaria

Thank you for your interest in contributing to Iskandaria! We're excited to have you join our community in building the modern digital library platform.

## 🌟 Ways to Contribute

- **🐛 Bug Reports** - Found something broken? Let us know!
- **💡 Feature Requests** - Have ideas for new functionality?
- **📖 Documentation** - Help improve our docs and examples
- **🔧 Code Contributions** - Fix bugs or implement new features
- **🧪 Testing** - Add test cases or improve test coverage
- **🎨 UI/UX** - Help design and improve the user interface
- **🌍 Translations** - Help make Iskandaria accessible globally

## 🚀 Getting Started

### Development Environment Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/yourusername/iskandaria.git
   cd iskandaria
   ```

2. **Install Dependencies**
   ```bash
   # Install Go 1.24 or higher
   # https://golang.org/doc/install
   
   # Install development tools
   make install
   ```

3. **Verify Setup**
   ```bash
   # Run tests
   make test
   
   # Run linting
   make lint
   
   # Generate proto files
   make generate
   ```

### Development Workflow

1. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/issue-description
   ```

2. **Make Your Changes**
   - Write clean, well-documented code
   - Follow existing code patterns and style
   - Add tests for new functionality
   - Update documentation as needed

3. **Test Your Changes**
   ```bash
   # Run all tests
   make test
   
   # Run tests with coverage
   make coverage
   
   # Run linting
   make lint
   ```

4. **Commit Your Changes**
   ```bash
   # Use conventional commits format
   git commit -m "feat: add new media import feature"
   # or
   git commit -m "fix: resolve playback issue in Safari"
   ```

5. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a Pull Request on GitHub

## 📝 Code Style Guidelines

### Go Code

- Follow standard Go conventions and idioms
- Use `gofmt` and `goimports` for formatting
- Write clear, self-documenting code
- Add comments for complex logic
- Keep functions small and focused
- Handle errors explicitly

### Protocol Buffers

- Use clear, descriptive message and field names
- Group related fields together
- Add comments for all services and messages
- Follow [Buf Style Guide](https://docs.buf.build/best-practices/style-guide)
- Version APIs appropriately (v1, v2, etc.)

### Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Test additions or changes
- `chore:` Maintenance tasks
- `perf:` Performance improvements

Examples:
```
feat: add podcast RSS feed import
fix: resolve memory leak in transcoding service
docs: update API documentation for song service
test: add unit tests for playlist management
```

## 🧪 Testing Requirements

### Test Coverage

- Maintain minimum 85% code coverage
- Write unit tests for all new functions
- Add integration tests for API endpoints
- Include edge cases and error scenarios

### Running Tests

```bash
# Run all tests
make test

# Run specific package tests
go test ./internal/service/song

# Run with verbose output
./scripts/run_tests.sh --verbose

# Generate coverage report
make coverage
```

### Writing Tests

```go
func TestSongService_Create(t *testing.T) {
    // Arrange
    service := NewSongService()
    request := &CreateSongRequest{
        Title: "Test Song",
        Artist: "Test Artist",
    }
    
    // Act
    response, err := service.Create(context.Background(), request)
    
    // Assert
    assert.NoError(t, err)
    assert.NotNil(t, response)
    assert.Equal(t, "Test Song", response.Title)
}
```

## 🏗️ Architecture Guidelines

### Service Design

- Follow Domain-Driven Design principles
- Keep services loosely coupled
- Use dependency injection
- Implement proper error handling
- Add appropriate logging

### API Design

- Use Protocol Buffers for API definitions
- Follow RESTful principles for HTTP endpoints
- Version APIs appropriately
- Provide comprehensive documentation
- Include validation rules

### Database

- Write migrations for schema changes
- Use transactions appropriately
- Optimize queries for performance
- Add appropriate indexes
- Document schema decisions

## 🔍 Code Review Process

### Before Submitting PR

1. **Self-Review Checklist**
   - [ ] Code follows project style guidelines
   - [ ] Tests pass locally
   - [ ] Coverage meets requirements (85%)
   - [ ] Documentation is updated
   - [ ] No debugging code left
   - [ ] Commit messages follow conventions

2. **PR Description Template**
   ```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update
   
   ## Testing
   - [ ] Unit tests pass
   - [ ] Integration tests pass
   - [ ] Manual testing completed
   
   ## Checklist
   - [ ] My code follows style guidelines
   - [ ] I have performed self-review
   - [ ] I have added tests
   - [ ] Documentation is updated
   ```

### Review Process

1. All PRs require at least one review
2. Address all feedback constructively
3. Keep PRs focused and small when possible
4. Link related issues in PR description
5. Ensure CI pipeline passes

## 🐛 Reporting Issues

### Bug Reports

When reporting bugs, please include:

1. **Environment Details**
   - OS and version
   - Go version
   - Iskandaria version/commit

2. **Steps to Reproduce**
   - Clear, numbered steps
   - Minimal reproduction case
   - Expected vs actual behavior

3. **Additional Context**
   - Error messages
   - Log outputs
   - Screenshots if applicable

### Feature Requests

For feature requests, please describe:

1. **Use Case**
   - What problem does it solve?
   - Who would benefit?

2. **Proposed Solution**
   - How should it work?
   - API/UI considerations

3. **Alternatives Considered**
   - Other approaches
   - Workarounds

## 🎯 Development Priorities

Current focus areas:

1. **Core Services**
   - Media import and processing
   - Streaming optimization
   - Search and discovery

2. **User Experience**
   - Web UI improvements
   - Mobile responsiveness
   - Performance optimization

3. **Infrastructure**
   - Scalability improvements
   - Monitoring and observability
   - Security enhancements

## 📚 Resources

### Documentation
- [README](README.md) - Project overview
- [API Docs](api-docs/) - API specifications
- [Architecture](docs/architecture.md) - System design

### External Resources
- [Go Documentation](https://golang.org/doc/)
- [Protocol Buffers](https://protobuf.dev/)
- [Buf Documentation](https://docs.buf.build/)
- [gRPC Go](https://grpc.io/docs/languages/go/)

## 🤝 Community

### Communication Channels
- [GitHub Issues](https://github.com/SebastienMelki/iskandaria/issues) - Bug reports and features
- [GitHub Discussions](https://github.com/SebastienMelki/iskandaria/discussions) - General discussion
- [Pull Requests](https://github.com/SebastienMelki/iskandaria/pulls) - Code contributions

### Code of Conduct

We are committed to providing a welcoming and inclusive environment. Please:

- Be respectful and considerate
- Welcome newcomers and help them get started
- Focus on constructive criticism
- Respect differing opinions
- Report inappropriate behavior

## 📜 License

By contributing to Iskandaria, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Iskandaria! Together, we're building the future of digital media libraries. 📚✨