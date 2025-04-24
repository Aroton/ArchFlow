#!/bin/bash

# This script updates the global RooCode custom modes settings
# by copying the custom_modes.json file from this repository.

# Define source and target paths
SOURCE_FILE="./custom_modes.json"
# Use $HOME for better portability
TARGET_DIR="$HOME/.vscode-server/data/User/globalStorage/rooveterinaryinc.roo-cline/settings"
TARGET_FILE="$TARGET_DIR/custom_modes.json"

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
  echo "Error: Source file not found at $SOURCE_FILE"
  exit 1
fi

# Check if target directory exists (more robust check)
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory not found at $TARGET_DIR"
    echo "Please ensure the RooCode extension is installed and has created its settings directory."
    exit 1
fi


# Copy the file
cp "$SOURCE_FILE" "$TARGET_FILE"

# Check if copy was successful
if [ $? -eq 0 ]; then
  echo "Successfully updated global custom modes:"
  echo "Source: $SOURCE_FILE"
  echo "Target: $TARGET_FILE"
else
  echo "Error: Failed to copy $SOURCE_FILE to $TARGET_FILE"
  exit 1
fi

echo "Note: You might need to restart VS Code for the changes to take effect."

exit 0