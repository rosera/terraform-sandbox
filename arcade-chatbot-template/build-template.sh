#!/bin/bash

# Define the input file containing filenames
INPUT_FILE="labs.txt"
# Define the source template directory
TEMPLATE_DIR="./template"

# --- Safety Checks ---

# Check if the input file exists and is readable
if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: Input file '$INPUT_FILE' not found."
  exit 1 # Exit with an error code
fi

if [ ! -r "$INPUT_FILE" ]; then
  echo "Error: Input file '$INPUT_FILE' is not readable."
  exit 1
fi

# Check if the template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
  echo "Error: Template directory '$TEMPLATE_DIR' not found."
  exit 1
fi

# --- Main Processing Loop ---

echo "Starting script..."

# Read the input file line by line
# IFS= prevents leading/trailing whitespace trimming
# -r prevents backslash interpretation
while IFS= read -r folder_name || [[ -n "$folder_name" ]]; do
  # Skip empty lines
  if [ -z "$folder_name" ]; then
    echo "Skipping empty line."
    continue # Go to the next line
  fi

  echo "Processing: '$folder_name'"

  # Check if a directory or file with this name already exists
  if [ -e "$folder_name" ]; then
    echo "  Warning: '$folder_name' already exists. Skipping."
    continue # Skip this entry
  fi

  # Create the new directory
  echo "  Creating directory '$folder_name'..."
  mkdir "$folder_name"
  if [ $? -ne 0 ]; then
    echo "  Error: Failed to create directory '$folder_name'. Skipping."
    continue # Skip to the next line if mkdir failed
  fi

  # Copy the contents of the template directory recursively
  # The -a flag is for archive mode (implies -r, preserves permissions, etc.)
  # Using "$TEMPLATE_DIR/." ensures the *contents* are copied, not the directory itself
  echo "  Copying contents from '$TEMPLATE_DIR' to '$folder_name'..."
  cp -a "$TEMPLATE_DIR/." "$folder_name/"
  if [ $? -ne 0 ]; then
    echo "  Error: Failed to copy contents to '$folder_name'."
    # Optional: You might want to remove the partially created folder on copy failure
    # echo "  Cleaning up empty directory '$folder_name'..."
    # rm -r "$folder_name"
  else
    echo "  Copy file: '$folder_name.tf' to folder: '$folder_name'."
    cp "$folder_name/qb/$folder_name.tf" "$folder_name"
    echo "  Clean up folder: '$folder_name/qb'."
    rm -r "$folder_name/qb"
    echo "  Successfully created '$folder_name' and copied template."
  fi

done < "$INPUT_FILE"

echo "Script finished."
exit 0 # Exit successfully
