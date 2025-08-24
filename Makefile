.PHONY: help build generate install clean test lint coverage lint-fix

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build all binaries in /cmd and put them in /bin
	@echo "Building binaries..."
	@mkdir -p bin
	@if [ -d "cmd" ]; then \
		for dir in cmd/*/; do \
			if [ -d "$$dir" ]; then \
				binary_name=$$(basename "$$dir"); \
				echo "Building $$binary_name..."; \
				go build -o bin/$$binary_name ./$$dir; \
			fi; \
		done; \
	else \
		echo "No cmd directory found, building main.go to bin/iskandaria"; \
		go build -o bin/iskandaria ./main.go; \
	fi

clean: ## Clean build artifacts and generated files
	@echo "Cleaning build artifacts..."
	@rm -rf bin/
	@rm -rf api/
	@rm -rf api-docs/
	@rm -rf coverage/
	@echo "Clean complete!"

coverage: ## Run tests with coverage analysis
	@echo "Running tests with coverage..."
	@./scripts/run_tests.sh

generate: ## Generate protos using buf (deletes generated files first)
	@echo "Cleaning generated files..."
	@rm -rf api/
	@echo "Generating protos with buf..."
	@buf generate

install: ## Install all necessary dependencies and development tools
	@echo "Installing Go dependencies..."
	@go mod tidy
	@echo "Installing buf..."
	@go install github.com/bufbuild/buf/cmd/buf@latest
	@echo "Installing golangci-lint..."
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@echo "Installing go-test-coverage for coverage badge generation..."
	@go install github.com/vladopajic/go-test-coverage/v2@latest
	@echo "Installing protoc-gen-go for protobuf generation..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@echo "Installing sebuf plugins..."
	@GOPROXY=direct go install github.com/SebastienMelki/sebuf/cmd/protoc-gen-go-oneof-helper@latest
	@GOPROXY=direct go install github.com/SebastienMelki/sebuf/cmd/protoc-gen-go-http@latest
	@GOPROXY=direct go install github.com/SebastienMelki/sebuf/cmd/protoc-gen-openapiv3@latest
	@echo "✅ All tools installed!"

lint: ## Run golangci-lint
	@echo "Running golangci-lint..."
	@golangci-lint run

lint-fix: ## Run golangci-lint
	@echo "Running golangci-lint..."
	@golangci-lint run --fix

test: ## Run tests
	@echo "Running tests..."
	@./scripts/run_tests.sh --fast

# Default target
.DEFAULT_GOAL := help