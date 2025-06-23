#!/bin/bash

# update_global_claude_commands.sh
# Copy ArchFlow Claude Code commands to personal ~/.claude/commands/ directory

# set -e disabled due to color output issues
# Exit on errors will be handled manually

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Script directory (where this script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude/commands"
TARGET_DIR="$HOME/.claude/commands"

print_status "Updating global Claude Code commands..."
print_status "Source: $SOURCE_DIR"
print_status "Target: $TARGET_DIR"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    print_error "Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

# Create target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    print_status "Creating target directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# List of ArchFlow command files to copy
ARCHFLOW_COMMANDS=(
    "archflow.md"
)

# Copy each command file
COPIED_COUNT=0
SKIPPED_COUNT=0

for cmd_file in "${ARCHFLOW_COMMANDS[@]}"; do
    source_file="$SOURCE_DIR/$cmd_file"
    target_file="$TARGET_DIR/$cmd_file"

    if [ -f "$source_file" ]; then
        # Check if target file exists and is different
        if [ -f "$target_file" ]; then
            if cmp -s "$source_file" "$target_file"; then
                print_status "Skipping $cmd_file (already up to date)"
                ((SKIPPED_COUNT++))
                continue
            else
                print_warning "Overwriting existing $cmd_file"
            fi
        fi

        # Copy the file
        cp "$source_file" "$target_file"
        print_success "Copied $cmd_file"
        ((COPIED_COUNT++))
    else
        print_warning "Source file not found: $source_file"
    fi
done

# Summary
echo
print_status "Update completed:"
print_status "  - $COPIED_COUNT files copied"
print_status "  - $SKIPPED_COUNT files skipped (up to date)"

if [ $COPIED_COUNT -gt 0 ]; then
    echo
    print_success "ArchFlow commands are now available globally!"
    print_status "You can now use these commands from any directory:"
    for cmd_file in "${ARCHFLOW_COMMANDS[@]}"; do
        cmd_name=$(echo "$cmd_file" | sed 's/\.md$//' | sed 's/archflow-/\/archflow:/')
        if [ -f "$TARGET_DIR/$cmd_file" ]; then
            print_status "  $cmd_name"
        fi
    done
else
    print_status "All commands were already up to date."
fi

echo
print_status "To verify installation, run: ls -la ~/.claude/commands/archflow-*"