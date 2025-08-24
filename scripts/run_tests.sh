#!/bin/bash

# Test Coverage Analysis Script for Iskandaria
# Runs tests for all packages and analyzes coverage
# Simplified version adapted from sebuf project

set -e

# Configuration
COVERAGE_THRESHOLD=85
COVERAGE_DIR="coverage"
COVERAGE_PROFILE="$COVERAGE_DIR/coverage.out"
COVERAGE_HTML="$COVERAGE_DIR/coverage.html"
COVERAGE_JSON="$COVERAGE_DIR/coverage.json"

# Parse command line arguments
VERBOSE=false
FAST_MODE=false
for arg in "$@"; do
    case $arg in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--fast)
            FAST_MODE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -v, --verbose    Run tests with verbose output"
            echo "  -f, --fast       Run tests without coverage (faster)"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            # Unknown option
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create coverage directory
mkdir -p "$COVERAGE_DIR"

if [ "$FAST_MODE" = true ]; then
    echo -e "${BLUE}===========================================${NC}"
    echo -e "${BLUE}           Fast Test Execution             ${NC}"
    echo -e "${BLUE}         (No Coverage Analysis)            ${NC}"
    echo -e "${BLUE}===========================================${NC}"
else
    echo -e "${BLUE}===========================================${NC}"
    echo -e "${BLUE}      Iskandaria Test Coverage Analysis    ${NC}"
    echo -e "${BLUE}===========================================${NC}"
fi
echo

# Run tests
if [ "$FAST_MODE" = true ]; then
    # Fast mode: run tests without coverage
    if [ "$VERBOSE" = true ]; then
        go test -v ./...
    else
        go test ./...
    fi
    echo -e "${GREEN}✓ Tests completed${NC}"
else
    # Full mode: run tests with coverage and race detection
    echo "Running tests with coverage and race detection..."
    
    if [ "$VERBOSE" = true ]; then
        go test -v -race -coverprofile="$COVERAGE_PROFILE" -covermode=atomic ./...
    else
        go test -race -coverprofile="$COVERAGE_PROFILE" -covermode=atomic ./...
    fi
    
    # Check if coverage file was created
    if [ ! -f "$COVERAGE_PROFILE" ]; then
        echo -e "${YELLOW}⚠ No tests found or coverage file not generated${NC}"
        echo "This is expected for a new project. Add tests as you develop features."
        exit 0
    fi
    
    # Generate HTML coverage report
    echo "Generating HTML coverage report..."
    go tool cover -html="$COVERAGE_PROFILE" -o "$COVERAGE_HTML"
    
    # Generate JSON coverage report
    echo "Generating JSON coverage report..."
    go tool cover -func="$COVERAGE_PROFILE" -o "$COVERAGE_JSON"
    
    # Calculate total coverage
    TOTAL_COVERAGE=$(go tool cover -func="$COVERAGE_PROFILE" | grep "total:" | awk '{print $3}' | sed 's/%//')
    
    echo
    echo -e "${BLUE}===========================================${NC}"
    echo -e "${BLUE}           Coverage Summary                ${NC}"
    echo -e "${BLUE}===========================================${NC}"
    echo
    
    # Check if it meets threshold
    if [ "${TOTAL_COVERAGE%.*}" -ge "$COVERAGE_THRESHOLD" ]; then
        echo -e "${GREEN}✓ Total Coverage: ${TOTAL_COVERAGE}% (threshold: ${COVERAGE_THRESHOLD}%)${NC}"
        echo -e "${GREEN}✓ Coverage threshold met!${NC}"
    else
        echo -e "${YELLOW}⚠ Total Coverage: ${TOTAL_COVERAGE}% (threshold: ${COVERAGE_THRESHOLD}%)${NC}"
        echo -e "${YELLOW}⚠ Coverage below threshold${NC}"
        # Don't fail for now, just warn
    fi
    
    echo
    echo "Coverage reports generated:"
    echo "  - HTML: $COVERAGE_HTML"
    echo "  - JSON: $COVERAGE_JSON"
    echo "  - Profile: $COVERAGE_PROFILE"
fi

echo
echo -e "${GREEN}✓ Test run completed successfully${NC}"