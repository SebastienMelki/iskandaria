.PHONY: help build generate install clean

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

generate: ## Generate protos using buf (deletes generated files first)
	@echo "Cleaning generated files..."
	@rm -rf api/
	@echo "Generating protos with buf..."
	@buf generate

install: ## Install all necessary dependencies
	@echo "Installing Go dependencies..."
	@go mod tidy
	@echo "Installing buf..."
	@go install github.com/bufbuild/buf/cmd/buf@latest
	@echo "Installing golangci-lint..."
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@echo "All dependencies installed!"

clean: ## Clean build artifacts and generated files
	@echo "Cleaning build artifacts..."
	@rm -rf bin/
	@rm -rf api/
	@echo "Clean complete!"

# Default target
.DEFAULT_GOAL := help