#!/bin/bash

# install_claude.sh
# Install ArchFlow for Claude Code - copies templates and commands

# Exit on errors
set -e

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

# Source and target directories
ARCHFLOW_DIR="$HOME/.archflow"
TEMPLATES_DIR="$ARCHFLOW_DIR/templates"
AGENTS_DIR="$ARCHFLOW_DIR/agents"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

print_status "Installing ArchFlow for Claude Code..."

# Create ArchFlow directories
print_status "Creating ArchFlow directories..."
mkdir -p "$TEMPLATES_DIR/architecture/adr"
mkdir -p "$TEMPLATES_DIR/architecture/features"
mkdir -p "$TEMPLATES_DIR/plans"
mkdir -p "$AGENTS_DIR"
mkdir -p "$CLAUDE_COMMANDS_DIR"

# Copy template files
print_status "Copying template files to $TEMPLATES_DIR..."

# Architecture templates
if [ -f "$SCRIPT_DIR/architecture/overall-architecture.md" ]; then
    cp "$SCRIPT_DIR/architecture/overall-architecture.md" "$TEMPLATES_DIR/architecture/"
    print_success "Copied overall-architecture.md"
else
    print_warning "overall-architecture.md not found"
fi

if [ -f "$SCRIPT_DIR/architecture/features/template.md" ]; then
    cp "$SCRIPT_DIR/architecture/features/template.md" "$TEMPLATES_DIR/architecture/features/"
    print_success "Copied feature template.md"
else
    print_warning "feature template.md not found"
fi

if [ -f "$SCRIPT_DIR/architecture/adr/0000-template.md" ]; then
    cp "$SCRIPT_DIR/architecture/adr/0000-template.md" "$TEMPLATES_DIR/architecture/adr/"
    print_success "Copied ADR template"
else
    print_warning "ADR template not found"
fi

if [ -f "$SCRIPT_DIR/plans/0000-template.md" ]; then
    cp "$SCRIPT_DIR/plans/0000-template.md" "$TEMPLATES_DIR/plans/"
    print_success "Copied plan template"
else
    print_warning "Plan template not found"
fi

# Copy agent mode documentation files
print_status "Copying agent documentation to $AGENTS_DIR..."

AGENT_FILES=(
    "archflow.md"
    "architecting.md"
    "planning.md"
    "executing.md"
    "verifying.md"
)

for agent_file in "${AGENT_FILES[@]}"; do
    if [ -f "$SCRIPT_DIR/agents/$agent_file" ]; then
        cp "$SCRIPT_DIR/agents/$agent_file" "$AGENTS_DIR/"
        print_success "Copied $agent_file"
    else
        print_warning "$agent_file not found"
    fi
done

# Copy Claude commands
print_status "Copying Claude commands to $CLAUDE_COMMANDS_DIR..."

# Source command file
SOURCE_COMMAND="$SCRIPT_DIR/.claude/commands/archflow.md"

if [ -f "$SOURCE_COMMAND" ]; then
    # Check if target file exists and is different
    TARGET_COMMAND="$CLAUDE_COMMANDS_DIR/archflow.md"
    
    if [ -f "$TARGET_COMMAND" ]; then
        if cmp -s "$SOURCE_COMMAND" "$TARGET_COMMAND"; then
            print_status "archflow.md is already up to date"
        else
            # Create backup
            cp "$TARGET_COMMAND" "$TARGET_COMMAND.backup.$(date +%Y%m%d_%H%M%S)"
            print_status "Created backup of existing archflow.md"
            
            # Copy new version
            cp "$SOURCE_COMMAND" "$TARGET_COMMAND"
            print_success "Updated archflow.md"
        fi
    else
        # Copy new file
        cp "$SOURCE_COMMAND" "$TARGET_COMMAND"
        print_success "Installed archflow.md"
    fi
else
    print_error "archflow.md not found at $SOURCE_COMMAND"
    exit 1
fi

# Create a marker file to indicate installation
echo "$(date)" > "$ARCHFLOW_DIR/.installed_claude"

# Summary
echo
print_success "ArchFlow for Claude Code installation completed!"
echo
print_status "Installed components:"
print_status "  - Templates: $TEMPLATES_DIR"
print_status "  - Agent docs: $AGENTS_DIR"
print_status "  - Commands: $CLAUDE_COMMANDS_DIR/archflow.md"
echo
print_status "Available commands:"
print_status "  - /archflow \"feature description\" - Execute complete ArchFlow workflow"
echo
print_status "Next steps:"
print_status "1. Use 'init_adr_workspace.sh' to initialize a new project with ArchFlow"
print_status "2. Run '/archflow' command in Claude Code to start a workflow"
echo
print_status "To update ArchFlow, run this script again."
print_status "To verify installation: ls -la ~/.claude/commands/archflow*"

exit 0