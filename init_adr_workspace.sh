#!/bin/bash

# This script initializes the current working directory with the Archflow structure.
# It creates the necessary folders and copies template files from the ArchFlow repo.
# Usage: Run this script from the directory you want to initialize.
# Example:
#   mkdir my-new-project
#   cd my-new-project
#   /path/to/ArchFlow/init_adr_workspace.sh # Execute the script here

# --- Determine Paths ---
# Get the directory where this script itself is located.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Assume the ArchFlow repo (containing templates) is where the script resides.
# If the script is moved elsewhere, this path needs adjustment.
SOURCE_REPO_DIR="$SCRIPT_DIR"

# Target directory is the current working directory
TARGET_DIR=$(pwd)

# Define source template paths relative to the script's location
SOURCE_OVERALL_ARCH="$SOURCE_REPO_DIR/architecture/overall-architecture.md"
SOURCE_FEATURE_TEMPLATE="$SOURCE_REPO_DIR/architecture/features/template.md"
SOURCE_ADR_TEMPLATE="$SOURCE_REPO_DIR/architecture/adr/0000-template.md"

# --- Safety Check ---
# Check if the current directory already contains Archflow structure elements
if [ -d "$TARGET_DIR/architecture" ] || [ -d "$TARGET_DIR/plans" ] || [ -d "$TARGET_DIR/src" ]; then
  echo "Warning: It looks like Archflow structure might already exist in '$TARGET_DIR'."
  read -p "Do you want to proceed and potentially overwrite existing structure/templates? (y/N): " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Initialization cancelled."
    exit 0
  fi
fi

# --- Directory Creation ---
echo "Initializing Archflow workspace in the current directory: $TARGET_DIR"
echo "Creating directories..."
mkdir -p "$TARGET_DIR/architecture/features" || { echo "Error creating features dir"; exit 1; }
mkdir -p "$TARGET_DIR/architecture/adr" || { echo "Error creating adr dir"; exit 1; }
mkdir -p "$TARGET_DIR/architecture/diagrams" || { echo "Error creating diagrams dir"; exit 1; }
mkdir -p "$TARGET_DIR/plans" || { echo "Error creating plans dir"; exit 1; }
mkdir -p "$TARGET_DIR/runtime_checkpoints" || { echo "Error creating runtime_checkpoints dir"; exit 1; }
echo "Directories created successfully."

# --- Template Copying ---
echo "Copying template files..."

copy_template() {
  local src="$1"
  local dest_dir="$2"
  local dest_file="$dest_dir/$(basename "$src")"

  if [ ! -f "$src" ]; then
    echo "  - Error: Source template file not found: $src"
    echo "           Please ensure this script is located in the root of the ArchFlow repository."
    return 1 # Indicate failure
  fi

  # Check if destination file exists before copying
  if [ -f "$dest_file" ]; then
      echo "  - Warning: Template file already exists, skipping copy: $dest_file"
      return 0 # Indicate success (or skip)
  fi

  cp "$src" "$dest_file"
  if [ $? -eq 0 ]; then
    echo "  - Copied: $(basename "$src") -> $dest_file"
    return 0 # Indicate success
  else
    echo "  - Error: Failed to copy $(basename "$src") to $dest_file"
    return 1 # Indicate failure
  fi
}

# Define target directories relative to the current directory
TARGET_ARCH_DIR="$TARGET_DIR/architecture"
TARGET_FEATURES_DIR="$TARGET_DIR/architecture/features"
TARGET_ADR_DIR="$TARGET_DIR/architecture/adr"

# Perform copies
copy_template "$SOURCE_OVERALL_ARCH" "$TARGET_ARCH_DIR"
copy_template "$SOURCE_FEATURE_TEMPLATE" "$TARGET_FEATURES_DIR"
copy_template "$SOURCE_ADR_TEMPLATE" "$TARGET_ADR_DIR"

# --- Completion Message ---
echo ""
echo "Archflow workspace initialization complete in '$TARGET_DIR'."
echo "Next steps:"
echo "1. git init (if not already a git repository)"
echo "2. Start developing using the Archflow process!"

exit 0