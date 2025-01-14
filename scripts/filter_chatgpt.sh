#!/bin/bash

# Define constants
DEFAULT_INPUT_FILE="conversations.json"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DEFAULT_OUTPUT_DIR="output_$TIMESTAMP"

# Initialize variables
INPUT_FILE=""
KEYWORD=""
OUTPUT_DIR=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --input) INPUT_FILE="$2"; shift ;;
        --keyword) KEYWORD="$2"; shift ;;
        --output-dir) OUTPUT_DIR="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Interactive fallback
if [[ -z "$INPUT_FILE" ]]; then
    read -p "Enter the input file path (default: $DEFAULT_INPUT_FILE): " INPUT_FILE
    INPUT_FILE="${INPUT_FILE:-$DEFAULT_INPUT_FILE}"
fi

if [[ -z "$KEYWORD" ]]; then
    read -p "Enter the keyword to search for: " KEYWORD
fi

if [[ -z "$OUTPUT_DIR" ]]; then
    read -p "Enter the output directory (default: $DEFAULT_OUTPUT_DIR): " OUTPUT_DIR
    OUTPUT_DIR="${OUTPUT_DIR:-$DEFAULT_OUTPUT_DIR}"
fi

# Ensure required scripts are executable
if [ ! -x "./process_file.sh" ]; then
    echo "Error: 'process_file.sh' is not executable. Please check permissions."
    exit 1
fi

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Input file '$INPUT_FILE' not found. Please ensure it exists."
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Process the file
echo "Filtering conversations with keyword: '$KEYWORD'..."
./process_file.sh "$INPUT_FILE" "$KEYWORD" "$OUTPUT_DIR/filtered_conversations.json"

# Check if matches were found
if [ ! -s "$OUTPUT_DIR/filtered_conversations.json" ]; then
    echo "No matching conversations found."
    exit 0
fi

# Extract URLs from the filtered JSON
URLS=$(jq -r '.[].url' "$OUTPUT_DIR/filtered_conversations.json")
URL_COUNT=$(echo "$URLS" | wc -l)

# Ask for confirmation before opening URLs
echo "Found $URL_COUNT matching conversations. Do you want to open all URLs in your browser? (y/n)"
read -r CONFIRMATION

if [[ "$CONFIRMATION" =~ ^[Yy]$ ]]; then
    echo "Opening $URL_COUNT URLs..."
    echo "$URLS" | while read -r url; do
        xdg-open "$url" 2>/dev/null || open "$url" 2>/dev/null
    done
else
    echo "Aborted. The URLs have been saved in '$OUTPUT_DIR/filtered_conversations.json'."
fi

echo "Process complete. Filtered conversations saved in '$OUTPUT_DIR'."

