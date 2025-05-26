#!/bin/bash

# This script updates the global RooCode custom modes settings
# by copying the custom_modes.json file from this repository.

# Define source and target paths
SOURCE_FILE="./custom_modes.json"
# Use $HOME for better portability
TARGET_DIR="$HOME/.vscode-server/data/User/globalStorage/rooveterinaryinc.roo-cline/settings"
TARGET_FILE="$TARGET_DIR/custom_modes.yaml"

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


# Convert JSON to YAML and write to target file
# Ensure yq is installed: sudo apt-get install yq or brew install yq
if ! command -v yq &> /dev/null
then
    echo "Error: yq command could not be found. Please install yq."
    echo "e.g., sudo snap install yq (Debian/Ubuntu) or brew install yq (macOS)"
    exit 1
fi

# Create a temporary file to store yq error output
YQ_ERROR_LOG=$(mktemp)
if [ -z "$YQ_ERROR_LOG" ] || [ ! -f "$YQ_ERROR_LOG" ]; then
    echo "Error: Failed to create a temporary file for yq logs."
    exit 1
fi

# Attempt to convert and write, redirecting yq's stderr to the log file
yq -P "$SOURCE_FILE" > "$TARGET_FILE" 2> "$YQ_ERROR_LOG"

# Check if copy was successful
# Check the exit status of the yq command
if [ $? -eq 0 ]; then
  echo "Successfully updated global custom modes:"
  echo "Source: $SOURCE_FILE"
  echo "Target: $TARGET_FILE"
  rm -f "$YQ_ERROR_LOG" # Clean up temp file on success
else
  echo "Error: Failed to convert $SOURCE_FILE to YAML or write to $TARGET_FILE."
  # Check if yq produced any specific error output
  if [ -s "$YQ_ERROR_LOG" ]; then
    echo "-----------------------------------------"
    echo "Specific error details from yq:"
    cat "$YQ_ERROR_LOG"
    echo "-----------------------------------------"
  else
    echo "No specific error output was captured from yq."
  fi
  rm -f "$YQ_ERROR_LOG" # Clean up temp file on failure
  exit 1
fi

echo "Note: You might need to restart VS Code for the changes to take effect."

exit 0