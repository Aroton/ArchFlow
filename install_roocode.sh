#!/bin/bash

# install_roocode.sh
# Install ArchFlow for RooCode - copies templates, agents, and custom modes

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
ROOCODE_SETTINGS_DIR="$HOME/.vscode-server/data/User/globalStorage/rooveterinaryinc.roo-cline/settings"

print_status "Installing ArchFlow for RooCode..."

# Create ArchFlow directories
print_status "Creating ArchFlow directories..."
mkdir -p "$TEMPLATES_DIR/architecture/adr"
mkdir -p "$TEMPLATES_DIR/architecture/features"
mkdir -p "$TEMPLATES_DIR/plans"
mkdir -p "$AGENTS_DIR"

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

# Update RooCode custom modes
print_status "Updating RooCode custom modes..."

# Check if RooCode settings directory exists
if [ ! -d "$ROOCODE_SETTINGS_DIR" ]; then
    print_error "RooCode settings directory not found at $ROOCODE_SETTINGS_DIR"
    print_error "Please ensure the RooCode extension is installed and has been run at least once."
    exit 1
fi

# Check for yq
if ! command -v yq &> /dev/null; then
    print_error "yq command not found. Please install yq."
    print_status "Installation instructions:"
    print_status "  - Ubuntu/Debian: sudo snap install yq"
    print_status "  - macOS: brew install yq"
    print_status "  - Other: https://github.com/mikefarah/yq"
    exit 1
fi

# Convert custom_modes.json to YAML
SOURCE_MODES="$SCRIPT_DIR/custom_modes.json"
TARGET_MODES="$ROOCODE_SETTINGS_DIR/custom_modes.yaml"

if [ -f "$SOURCE_MODES" ]; then
    print_status "Converting and installing custom modes..."
    
    # Create backup if target exists
    if [ -f "$TARGET_MODES" ]; then
        cp "$TARGET_MODES" "$TARGET_MODES.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Created backup of existing custom_modes.yaml"
    fi
    
    # Convert JSON to YAML
    if yq -p=json "$SOURCE_MODES" > "$TARGET_MODES" 2>/dev/null; then
        print_success "Custom modes installed successfully"
    else
        print_error "Failed to convert custom_modes.json to YAML"
        exit 1
    fi
else
    print_error "custom_modes.json not found at $SOURCE_MODES"
    exit 1
fi

# Create a marker file to indicate installation
echo "$(date)" > "$ARCHFLOW_DIR/.installed_roocode"

# Summary
echo
print_success "ArchFlow for RooCode installation completed!"
echo
print_status "Installed components:"
print_status "  - Templates: $TEMPLATES_DIR"
print_status "  - Agent docs: $AGENTS_DIR"
print_status "  - Custom modes: $TARGET_MODES"
echo
print_status "Next steps:"
print_status "1. Restart VS Code for custom modes to take effect"
print_status "2. Use 'init_adr_workspace.sh' to initialize a new project with ArchFlow"
print_status "3. Select ArchFlow modes from the RooCode mode selector"
echo
print_status "To update ArchFlow, run this script again."

exit 0